part of 'add_available_dates_bloc.dart';

abstract class AddAvailableDatesState {}

class AddAvailableDatesInitial extends AddAvailableDatesState {}

class AddAvailableDatesLoading extends AddAvailableDatesState {}

class AddAvailableDatesSuccess extends AddAvailableDatesState {
  final AvailableDatesResponse response;

  AddAvailableDatesSuccess(this.response);
}

class AddAvailableDatesError extends AddAvailableDatesState {
  final String message;

  AddAvailableDatesError(this.message);
}
