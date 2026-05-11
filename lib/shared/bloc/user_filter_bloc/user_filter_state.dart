import 'package:equatable/equatable.dart';

import '../../data/models/user/user_model.dart';

// sentinel ثابت للتمييز بين "مش بعتلك حاجة" و "بعتلك null"
const _undefined = Object();

class UserFilterState extends Equatable {
  final List<UserModel> filteredList;
  final bool isLoading;

  final double minPrice;
  final double maxPrice;
  final int? selectedRate;
  final String? selectedRole;
  final String? selectedTrack;

  final bool isLastPage;
  final bool isLoadingMore;

  const UserFilterState({
    required this.filteredList,
    this.isLoading = false,
    this.minPrice = 20,
    this.maxPrice = 60,
    this.selectedRate,
    this.selectedRole,
    this.selectedTrack,
    this.isLastPage = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        filteredList,
        isLoading,
        minPrice,
        maxPrice,
        selectedRate,
        selectedRole,
        selectedTrack,
        isLastPage,
        isLoadingMore,
      ];

  UserFilterState copyWith({
    List<UserModel>? filteredList,
    bool? isLoading,
    double? minPrice,
    double? maxPrice,
    Object? selectedRate = _undefined,
    Object? selectedRole = _undefined,
    Object? selectedTrack = _undefined,
    bool? isLastPage,
    bool? isLoadingMore,
  }) {
    return UserFilterState(
      filteredList: filteredList ?? this.filteredList,
      isLoading: isLoading ?? this.isLoading,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedRate:
          selectedRate == _undefined ? this.selectedRate : selectedRate as int?,
      selectedRole: selectedRole == _undefined
          ? this.selectedRole
          : selectedRole as String?,
      selectedTrack: selectedTrack == _undefined
          ? this.selectedTrack
          : selectedTrack as String?,
      isLastPage: isLastPage ?? this.isLastPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
