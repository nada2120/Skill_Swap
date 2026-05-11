part of 'cancel_book_bloc.dart';

@immutable
sealed class CancelBookEvent {}

class CancelBookSession extends CancelBookEvent {
  final String id;
  final String? recipientId;

  CancelBookSession({required this.id, this.recipientId});
}
