import 'booking_details_error_response.dart';
import 'booking_details_success_response.dart';

sealed class BookingDetailsResponse {}

class BookingDetailsSuccess extends BookingDetailsResponse {
  final BookingDetailsSuccessResponse data;

  BookingDetailsSuccess(this.data);
}

class BookingDetailsFailure extends BookingDetailsResponse {
  final BookingDetailsErrorResponse error;

  BookingDetailsFailure(this.error);
}