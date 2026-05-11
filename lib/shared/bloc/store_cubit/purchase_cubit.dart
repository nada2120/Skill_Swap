import 'package:bloc/bloc.dart';

import '../../domain/repositories/store_repository.dart';
import '../../data/models/store/purchases.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final StoreRepository repository;

  PurchaseCubit(this.repository) : super(const PurchaseState());

  Future<void> getPurchases() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final response = await repository.getPurchases();

      emit(state.copyWith(
        isLoading: false,
        purchases: response.purchases,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  List<Purchases> getAvailableVouchers() {
    return state.purchases
        .where((p) => p.type == "voucher")
        .where((p) => p.isUsed == false)
        .where((v) {
      final date = DateTime.tryParse(v.validUntil ?? "");
      return date == null || date.isAfter(DateTime.now());
    }).toList();
  }

  List<Purchases> getPurchasesByType(String type) {
    return state.purchases.where((purchase) => purchase.type == type).toList();
  }
}
