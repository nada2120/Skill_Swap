import 'package:equatable/equatable.dart';

abstract class UserFilterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplyFiltersEvent extends UserFilterEvent {
  final double? minPrice;
  final double? maxPrice;
  final double? minRate;
  final String? role;
  final String? track;

  ApplyFiltersEvent({
    this.minPrice,
    this.maxPrice,
    this.minRate,
    this.role,
    this.track,
  });
}

class ResetFiltersEvent extends UserFilterEvent {}

class SearchUserEvent extends UserFilterEvent {
  final String query;

  SearchUserEvent(this.query);
}

enum SortType { priceLowToHigh, priceHighToLow, nameAZ, nameZA, rateHigh }

class SortUserEvent extends UserFilterEvent {
  final SortType type;

  SortUserEvent(this.type);
}

class LoadMoreUsersEvent extends UserFilterEvent {
  final int page;
  final int limit;
  final String? query;
  final double? minPrice;
  final double? maxPrice;
  final double? minRate;
  final String? role;
  final String? track;

  LoadMoreUsersEvent({
    required this.page,
    this.limit = 10,
    this.query,
    this.minPrice,
    this.maxPrice,
    this.minRate,
    this.role,
    this.track,
  });
}
