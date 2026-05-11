part of 'get_available_dates_bloc.dart';

abstract class GetAvailableDatesEvent {}

class FetchAvailableDates extends GetAvailableDatesEvent {
  final String instructorId;

  FetchAvailableDates(this.instructorId);
}
