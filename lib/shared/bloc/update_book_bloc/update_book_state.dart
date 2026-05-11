part of 'update_book_bloc.dart';

@immutable
sealed class UpdateBookState {}

final class UpdateBookInitial extends UpdateBookState {}

final class UpdateBookLoading extends UpdateBookState {}

final class UpdateBookSuccess extends UpdateBookState {
  final UpdateBookingSuccess success;

  UpdateBookSuccess({required this.success});
}

final class UpdateBookFailure extends UpdateBookState {
  final UpdateBookingFailure error;

  UpdateBookFailure({required this.error});
}
