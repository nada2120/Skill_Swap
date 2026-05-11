part of 'accepted_bookings_cubit.dart';

abstract class AcceptedBookingsState extends Equatable {
  const AcceptedBookingsState();

  @override
  List<Object?> get props => [];
}

class AcceptedBookingsInitial extends AcceptedBookingsState {}

class AcceptedBookingsLoading extends AcceptedBookingsState {}

class AcceptedBookingsLoaded extends AcceptedBookingsState {
  final List<AcceptedBookingsModel> bookings;

  const AcceptedBookingsLoaded({required this.bookings});

  @override
  List<Object?> get props => [bookings];
}

class AcceptedBookingsError extends AcceptedBookingsState {
  final String error;

  const AcceptedBookingsError({required this.error});

  @override
  List<Object?> get props => [error];
}
