import 'package:bloc/bloc.dart';

import '../../data/models/booking_availability/get_upcoming_sat.dart';
import '../../domain/repositories/booking_repository.dart';

part 'get_upcoming_sat_event.dart';

part 'get_upcoming_sat_state.dart';

class GetUpcomingSatBloc
    extends Bloc<GetUpcomingSatEvent, GetUpcomingSatState> {
  final BookingRepository repo;

  GetUpcomingSatBloc(this.repo) : super(GetUpcomingSatInitial()) {
    on<FetchUpcomingSat>((event, emit) async {
      emit(GetUpcomingSatLoading());
      try {
        final result = await repo.getUpcomingSat();
        emit(GetUpcomingSatSuccess(result));
      } catch (e) {
        emit(GetUpcomingSatError(e.toString()));
      }
    });
  }
}
