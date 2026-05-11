import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/update_booking/update_booking_request.dart';
import '../../data/models/update_booking/update_booking_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'update_book_event.dart';

part 'update_book_state.dart';

class UpdateBookBloc extends Bloc<UpdateBookEvent, UpdateBookState> {
  final BookingRepository repo;

  UpdateBookBloc(this.repo) : super(UpdateBookInitial()) {
    on<UpdateBookSession>((event, emit) async {
      emit(UpdateBookLoading());

      final response = await repo.updateBookSession(event.id, event.request);

      switch (response) {
        case UpdateBookingSuccess s:
          emit(UpdateBookSuccess(success: s));
          break;
        case UpdateBookingFailure f:
          emit(UpdateBookFailure(error: f));
          break;
      }
    });
  }
}
