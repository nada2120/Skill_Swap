import 'package:bloc/bloc.dart';

import '../../data/models/booking_availability/available_dates_response.dart';
import '../../data/models/booking_availability/set_available_dates.dart';
import '../../domain/repositories/booking_repository.dart';

part 'set_available_dates_event.dart';
part 'set_available_dates_state.dart';

class SetAvailableDatesBloc
    extends Bloc<SetAvailableDatesEvent, SetAvailableDatesState> {
  final BookingRepository repo;

  SetAvailableDatesBloc(this.repo) : super(SetAvailableDatesInitial()) {
    on<SubmitSetAvailableDates>((event, emit) async {
      emit(SetAvailableDatesLoading());
      try {
        final result = await repo.setAvailableDates(event.body);
        emit(SetAvailableDatesSuccess(result));
      } catch (e) {
        emit(SetAvailableDatesError(e.toString()));
      }
    });
  }
}
