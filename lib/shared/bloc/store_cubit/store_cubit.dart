import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../../mobile/presentation/game_stor/models/store_item_model.dart';
import '../../data/models/store/item_mapper.dart';
import '../../domain/repositories/store_repository.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository repository;

  StoreCubit(this.repository)
      : super(StoreState(
          remaining: Duration.zero,
          elapsed: Duration.zero,
          items: [],
        )) {
    _initTimer();
  }

  Timer? timer;
  final box = GetStorage();

  static const String endTimeKey = "store_end_time";
  static const String monthStartKey = "month_start";
  static const String claimedKey = "claimed";

  Future<void> getStoreItems({required bool freeOnly}) async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await repository.getItems();

      final items = response.items
          .map((e) => e.toStoreItem())
          .where((item) => freeOnly ? item.price == 0 : item.price > 0)
          .toList();

      emit(state.copyWith(
        items: items,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> buyItem(String id) async {
    try {
      final response = await repository.purchaseItem(id);

      final updatedItems = state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(isPurchased: true);
        }
        return item;
      }).toList();

      emit(state.copyWith(
        items: updatedItems,
        successMessage: response.message,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearMessage() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
    ));
  }

  Future<List<StoreItem>> getFreeStoreItems() async {
    final response = await repository.getItems();

    return response.items
        .map((e) => e.toStoreItem())
        .where((item) => item.price == 0)
        .toList();
  }

  List<StoreItem> getRewardItemsByRank(int rank) {
    final freeItems = state.items.where((e) => e.price == 0).toList();

    final rewardsMap = {
      1: ["50% Discount", "Top1 Bubble", "20 free hours"],
      2: ["25% Discount", "Top2 Bubble", "15 free hours"],
      3: ["15% Discount", "Top3 Bubble", "10 free hours"],
      4: ["10% Discount", "5 free hours"],
    };

    final rewardTitles = rewardsMap[rank] ?? [];

    return freeItems
        .where((item) => rewardTitles.contains(item.title))
        .toList();
  }

  DateTime getNextSaturdayMidnight() {
    final now = DateTime.now();
    int daysToAdd = (6 - now.weekday) % 7;

    if (daysToAdd == 0 && now.hour > 0) {
      daysToAdd = 7;
    }

    final next = DateTime(now.year, now.month, now.day + daysToAdd);
    return DateTime(next.year, next.month, next.day);
  }

  void _initTimer() {
    int? stored = box.read(endTimeKey);

    DateTime endTime;

    if (stored == null) {
      endTime = getNextSaturdayMidnight();
      box.write(endTimeKey, endTime.millisecondsSinceEpoch);
    } else {
      endTime = DateTime.fromMillisecondsSinceEpoch(stored);

      if (DateTime.now().isAfter(endTime)) {
        endTime = getNextSaturdayMidnight();
        box.write(endTimeKey, endTime.millisecondsSinceEpoch);
      }
    }

    _startTimer(endTime);
  }

  void _startTimer(DateTime endTime) {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = endTime.difference(DateTime.now());

      if (remaining.isNegative) {
        timer?.cancel();

        final newEnd = getNextSaturdayMidnight();
        box.write(endTimeKey, newEnd.millisecondsSinceEpoch);

        _startTimer(newEnd);
        return;
      }

      emit(state.copyWith(
        remaining: remaining,
        isClaimPhase: isClaimPhase(),
      ));
    });
  }

  DateTime getMonthStart() {
    final stored = box.read(monthStartKey);

    if (stored != null) {
      return DateTime.fromMillisecondsSinceEpoch(stored);
    }

    final now = DateTime.now();
    box.write(monthStartKey, now.millisecondsSinceEpoch);
    return now;
  }

  DateTime getClaimStart() {
    return getMonthStart().add(const Duration(days: 30));
  }

  DateTime getClaimEnd() {
    return getClaimStart().add(const Duration(hours: 1));
  }

  bool isClaimPhase() {
    final now = DateTime.now();
    return now.isAfter(getClaimStart()) && now.isBefore(getClaimEnd());
  }

  Future<void> collectRewards(int myRank) async {
    try {
      emit(state.copyWith(isLoading: true));

      final rewards = getRewardItemsByRank(myRank);

      for (final item in rewards) {
        await buyItem(item.id);
      }

      box.write(claimedKey, true);

      emit(state.copyWith(
        isLoading: false,
        isClaimed: true,
        successMessage: "Rewards collected",
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> handleRewards(int myRank) async {
    final now = DateTime.now();
    final claimEnd = getClaimEnd();

    final claimed = box.read(claimedKey) ?? false;

    if (now.isAfter(claimEnd) && !claimed) {
      if (myRank <= 10) {
        final rewards = getRewardItemsByRank(myRank);

        for (final item in rewards) {
          await repository.purchaseItem(item.id);
        }
      }

      box.write(claimedKey, true);
    }

    emit(state.copyWith(
      isClaimPhase: isClaimPhase(),
    ));
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
