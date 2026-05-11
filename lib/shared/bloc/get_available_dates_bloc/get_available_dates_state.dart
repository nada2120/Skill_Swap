part of 'get_available_dates_bloc.dart';

abstract class GetAvailableDatesState {}

class GetAvailableDatesInitial extends GetAvailableDatesState {}

class GetAvailableDatesLoading extends GetAvailableDatesState {}

class GetAvailableDatesSuccess extends GetAvailableDatesState {
  final GetAvailableDates data;

  GetAvailableDatesSuccess(this.data);
}

class GetAvailableDatesError extends GetAvailableDatesState {
  final String message;

  GetAvailableDatesError(this.message);
}
