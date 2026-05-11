part of 'delete_available_dates_bloc.dart';

@immutable
sealed class DeleteAvailableDatesEvent {}

class DeleteAvailableDates extends DeleteAvailableDatesEvent {
  final String idOrDate;

  DeleteAvailableDates({required this.idOrDate});
}
