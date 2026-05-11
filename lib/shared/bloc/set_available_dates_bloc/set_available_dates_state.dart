part of 'set_available_dates_bloc.dart';

abstract class SetAvailableDatesState {}

class SetAvailableDatesInitial extends SetAvailableDatesState {}

class SetAvailableDatesLoading extends SetAvailableDatesState {}

class SetAvailableDatesSuccess extends SetAvailableDatesState {
  final AvailableDatesResponse response;

  SetAvailableDatesSuccess(this.response);
}

class SetAvailableDatesError extends SetAvailableDatesState {
  final String message;

  SetAvailableDatesError(this.message);
}
