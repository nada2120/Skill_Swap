part of 'delete_book_bloc.dart';

@immutable
sealed class DeleteBookEvent {}

class DeleteBookSession extends DeleteBookEvent {
  final String id;

  DeleteBookSession({required this.id});
}
