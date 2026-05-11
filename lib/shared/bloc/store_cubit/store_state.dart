import 'package:equatable/equatable.dart';

import '../../../mobile/presentation/game_stor/models/store_item_model.dart';

class StoreState extends Equatable {
  final Duration remaining;
  final Duration elapsed;
  final List<StoreItem> items;

  final bool isLoading;
  final bool isClaimPhase;
  final bool isClaimed;

  final String? errorMessage;
  final String? successMessage;

  const StoreState({
    required this.remaining,
    required this.elapsed,
    required this.items,
    this.isLoading = false,
    this.isClaimPhase = false,
    this.isClaimed = false,
    this.errorMessage,
    this.successMessage,
  });

  StoreState copyWith({
    Duration? remaining,
    Duration? elapsed,
    List<StoreItem>? items,
    bool? isLoading,
    bool? isClaimPhase,
    bool? isClaimed,
    String? errorMessage,
    String? successMessage,
  }) {
    return StoreState(
      remaining: remaining ?? this.remaining,
      elapsed: elapsed ?? this.elapsed,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isClaimPhase: isClaimPhase ?? this.isClaimPhase,
      isClaimed: isClaimed ?? this.isClaimed,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        remaining,
        elapsed,
        items,
        isLoading,
        isClaimPhase,
        isClaimed,
        errorMessage,
        successMessage,
      ];
}
