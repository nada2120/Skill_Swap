import 'delete_booking_error_response.dart';
import 'delete_booking_success_response.dart';

sealed class DeleteBookingResponse {}

class DeleteBookingSuccess extends DeleteBookingResponse {
  final DeleteBookingSuccessResponse data;

  DeleteBookingSuccess(this.data);
}

class DeleteBookingFailure extends DeleteBookingResponse {
  final DeleteBookingErrorResponse error;

  DeleteBookingFailure(this.error);
}
