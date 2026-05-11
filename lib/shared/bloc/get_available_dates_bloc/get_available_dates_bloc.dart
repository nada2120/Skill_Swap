import 'package:bloc/bloc.dart';

import '../../data/models/booking_availability/get_available_dates.dart';
import '../../domain/repositories/booking_repository.dart';

part 'get_available_dates_event.dart';

part 'get_available_dates_state.dart';

class GetAvailableDatesBloc
    extends Bloc<GetAvailableDatesEvent, GetAvailableDatesState> {
  final BookingRepository repo;

  GetAvailableDatesBloc(this.repo) : super(GetAvailableDatesInitial()) {
    on<FetchAvailableDates>((event, emit) async {
      emit(GetAvailableDatesLoading());
      try {
        final result = await repo.getAvailableDates(event.instructorId);
        emit(GetAvailableDatesSuccess(result));
      } catch (e) {
        emit(GetAvailableDatesError(e.toString()));
      }
    });
  }
}
