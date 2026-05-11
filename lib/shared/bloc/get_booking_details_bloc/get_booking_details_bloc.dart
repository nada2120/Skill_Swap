import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/booking_details/booking_details_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'get_booking_details_event.dart';

part 'get_booking_details_state.dart';

class GetBookingDetailsBloc
    extends Bloc<GetBookingDetailsEvent, GetBookingDetailsState> {
  final BookingRepository repo;

  GetBookingDetailsBloc(this.repo) : super(GetBookingDetailsInitial()) {
    on<GetBookingDetailsRequested>((event, emit) async {
      emit(GetBookingDetailsLoading());

      final response = await repo.getBookingDetails(event.id);

      switch (response) {
        case BookingDetailsSuccess s:
          emit(GetBookingDetailsSuccess(success: s));
          break;
        case BookingDetailsFailure f:
          emit(GetBookingDetailsError(error: f));
          break;
      }
    });
  }
}
