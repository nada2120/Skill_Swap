part of 'add_available_dates_bloc.dart';

abstract class AddAvailableDatesEvent {}

class SubmitAvailableDates extends AddAvailableDatesEvent {
  final AddAvailableDates body;

  SubmitAvailableDates(this.body);
}
