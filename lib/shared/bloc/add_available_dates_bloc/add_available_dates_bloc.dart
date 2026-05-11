import 'package:bloc/bloc.dart';

import '../../data/models/booking_availability/add_available_dates.dart';
import '../../data/models/booking_availability/available_dates_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'add_available_dates_event.dart';

part 'add_available_dates_state.dart';

class AddAvailableDatesBloc
    extends Bloc<AddAvailableDatesEvent, AddAvailableDatesState> {
  final BookingRepository repo;

  AddAvailableDatesBloc(this.repo) : super(AddAvailableDatesInitial()) {
    on<SubmitAvailableDates>((event, emit) async {
      emit(AddAvailableDatesLoading());
      try {
        final result = await repo.addAvailableDates(event.body);
        emit(AddAvailableDatesSuccess(result));
      } catch (e) {
        emit(AddAvailableDatesError(e.toString()));
      }
    });
  }
}
