part of 'update_book_bloc.dart';

@immutable
sealed class UpdateBookEvent {}

class UpdateBookSession extends UpdateBookEvent {
  final String id;
  final UpdateBookingRequest request;

  UpdateBookSession({required this.id, required this.request});
}
