import 'cancel_booking_error_response.dart';
import 'cancel_booking_success_response.dart';

sealed class CancelBookingResponse {}

class CancelBookingSuccess extends CancelBookingResponse {
  final CancelBookingSuccessResponse data;

  CancelBookingSuccess(this.data);
}

class CancelBookingFailure extends CancelBookingResponse {
  final CancelBookingErrorResponse error;

  CancelBookingFailure(this.error);
}
