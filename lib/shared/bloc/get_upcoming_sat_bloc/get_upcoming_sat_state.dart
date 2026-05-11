part of 'get_upcoming_sat_bloc.dart';

abstract class GetUpcomingSatState {}

class GetUpcomingSatInitial extends GetUpcomingSatState {}

class GetUpcomingSatLoading extends GetUpcomingSatState {}

class GetUpcomingSatSuccess extends GetUpcomingSatState {
  final GetUpcomingSat data;

  GetUpcomingSatSuccess(this.data);
}

class GetUpcomingSatError extends GetUpcomingSatState {
  final String message;

  GetUpcomingSatError(this.message);
}
