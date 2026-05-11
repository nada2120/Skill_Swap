import 'pay_booking_error_response.dart';
import 'pay_booking_success_response.dart';

sealed class PayBookingResponse {}

class PayBookingSuccess extends PayBookingResponse {
  final PayBookingSuccessResponse data;

  PayBookingSuccess(this.data);
}

class PayBookingFailure extends PayBookingResponse {
  final PayBookingErrorResponse error;

  PayBookingFailure(this.error);
}
