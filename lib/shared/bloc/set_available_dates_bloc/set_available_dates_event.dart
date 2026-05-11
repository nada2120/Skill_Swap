part of 'set_available_dates_bloc.dart';

abstract class SetAvailableDatesEvent {}

class SubmitSetAvailableDates extends SetAvailableDatesEvent {
  final SetAvailableDates body;

  SubmitSetAvailableDates(this.body);
}
