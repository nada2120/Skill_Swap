part of 'delete_available_dates_bloc.dart';

@immutable
sealed class DeleteAvailableDatesState {}

final class DeleteAvailableDatesInitial extends DeleteAvailableDatesState {}

final class DeleteAvailableDatesLoading extends DeleteAvailableDatesState {}

final class DeleteAvailableDatesSuccess extends DeleteAvailableDatesState {
  final AvailableDatesResponse response;

  DeleteAvailableDatesSuccess(this.response);
}

final class DeleteAvailableDatesFailure extends DeleteAvailableDatesState {
  final String message;

  DeleteAvailableDatesFailure(this.message);
}
