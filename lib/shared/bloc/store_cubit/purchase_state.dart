import 'package:equatable/equatable.dart';

import '../../data/models/store/purchases.dart';

class PurchaseState extends Equatable {
  final bool isLoading;
  final List<Purchases> purchases;
  final String? error;

  const PurchaseState({
    this.isLoading = false,
    this.purchases = const [],
    this.error,
  });

  PurchaseState copyWith({
    bool? isLoading,
    List<Purchases>? purchases,
    String? error,
  }) {
    return PurchaseState(
      isLoading: isLoading ?? this.isLoading,
      purchases: purchases ?? this.purchases,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, purchases, error];
}
