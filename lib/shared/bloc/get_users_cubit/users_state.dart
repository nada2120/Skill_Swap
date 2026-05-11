import '../../data/models/user/user_model.dart';

sealed class UsersState {}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersLoaded extends UsersState {
  final List<UserModel> users;
  final bool isLastPage;
  final bool isLoadingMore;

  UsersLoaded(
    this.users, {
    this.isLastPage = false,
    this.isLoadingMore = false,
  });

  UsersLoaded copyWith({
    List<UserModel>? users,
    bool? isLastPage,
    bool? isLoadingMore,
  }) {
    return UsersLoaded(
      users ?? this.users,
      isLastPage: isLastPage ?? this.isLastPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}
