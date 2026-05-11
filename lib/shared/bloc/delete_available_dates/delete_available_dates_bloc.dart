import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/booking_availability/available_dates_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'delete_available_dates_event.dart';

part 'delete_available_dates_state.dart';

class DeleteAvailableDatesBloc
    extends Bloc<DeleteAvailableDatesEvent, DeleteAvailableDatesState> {
  final BookingRepository repo;

  DeleteAvailableDatesBloc(this.repo) : super(DeleteAvailableDatesInitial()) {
    on<DeleteAvailableDates>((event, emit) async {
      emit(DeleteAvailableDatesLoading());
      try {
        final response = await repo.deleteAvailableDate(event.idOrDate);
        emit(DeleteAvailableDatesSuccess(response));
      } catch (e) {
        emit(DeleteAvailableDatesFailure(e.toString()));
      }
    });
  }
}
