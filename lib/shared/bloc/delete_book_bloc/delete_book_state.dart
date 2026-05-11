part of 'delete_book_bloc.dart';

@immutable
sealed class DeleteBookState {}

final class DeleteBookInitial extends DeleteBookState {}

final class DeleteBookLoading extends DeleteBookState {}

final class DeleteBookSuccess extends DeleteBookState {
  final DeleteBookingSuccess success;

  DeleteBookSuccess({required this.success});
}

final class DeleteBookFailure extends DeleteBookState {
  final DeleteBookingFailure error;

  DeleteBookFailure({required this.error});
}
