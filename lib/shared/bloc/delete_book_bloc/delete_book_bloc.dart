import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/delete_booking/delete_booking_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'delete_book_event.dart';

part 'delete_book_state.dart';

class DeleteBookBloc extends Bloc<DeleteBookEvent, DeleteBookState> {
  final BookingRepository repo;

  DeleteBookBloc(this.repo) : super(DeleteBookInitial()) {
    on<DeleteBookSession>((event, emit) async {
      emit(DeleteBookLoading());

      final response = await repo.deleteBookSession(event.id);

      switch (response) {
        case DeleteBookingSuccess s:
          emit(DeleteBookSuccess(success: s));
          break;
        case DeleteBookingFailure f:
          emit(DeleteBookFailure(error: f));
          break;
      }
    });
  }
}
