part of 'cancel_book_bloc.dart';

@immutable
sealed class CancelBookState {}

final class CancelBookInitial extends CancelBookState {}

final class CancelBookLoading extends CancelBookState {}

final class CancelBookSuccess extends CancelBookState {
  final CancelBookingSuccess success;

  CancelBookSuccess({required this.success});
}

final class CancelBookFailure extends CancelBookState {
  final CancelBookingFailure error;

  CancelBookFailure({required this.error});
}
