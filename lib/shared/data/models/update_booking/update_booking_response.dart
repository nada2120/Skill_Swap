import 'update_booking_error_response.dart';
import 'update_booking_success_response.dart';

sealed class UpdateBookingResponse {}

class UpdateBookingSuccess extends UpdateBookingResponse {
  final UpdateBookingSuccessResponse data;

  UpdateBookingSuccess(this.data);
}

class UpdateBookingFailure extends UpdateBookingResponse {
  final UpdateBookingErrorResponse error;

  UpdateBookingFailure(this.error);
}
