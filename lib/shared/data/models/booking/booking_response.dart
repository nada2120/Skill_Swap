import 'booking_error_response.dart';
import 'booking_success_response.dart';

sealed class BookingResponse {}

class BookingSuccess extends BookingResponse {
  final BookingSuccessResponse data;

  BookingSuccess(this.data);
}

class BookingFailure extends BookingResponse {
  final BookingErrorResponse error;

  BookingFailure(this.error);
}
