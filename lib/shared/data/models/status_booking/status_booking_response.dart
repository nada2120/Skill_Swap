import 'status_booking_error_response.dart';
import 'status_booking_success_response.dart';

sealed class StatusBookingResponse {}

class StatusBookingSuccess extends StatusBookingResponse {
  final StatusBookingSuccessResponse data;

  StatusBookingSuccess(this.data);
}

class StatusBookingFailure extends StatusBookingResponse {
  final StatusBookingErrorResponse error;

  StatusBookingFailure(this.error);
}
