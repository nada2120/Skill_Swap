part of 'status_book_bloc.dart';

@immutable
abstract class StatusBookState {}

class StatusBookInitial extends StatusBookState {}

class StatusBookLoadingForSession extends StatusBookState {
  final String id;

  StatusBookLoadingForSession({required this.id});
}

class StatusBookSuccess extends StatusBookState {
  final StatusBookingSuccess success;
  final String sessionId;

  StatusBookSuccess({required this.success, required this.sessionId});
}

class StatusBookFailure extends StatusBookState {
  final StatusBookingErrorResponse error;
  final String sessionId;

  StatusBookFailure({required this.error, required this.sessionId});
}
