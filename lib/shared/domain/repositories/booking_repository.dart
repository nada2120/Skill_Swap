import 'package:skill_swap/shared/data/models/join_session/join_session_response.dart';

import '../../data/models/accepted_booking/accepted_booking_response.dart';
import '../../data/models/booking/booking_request.dart';
import '../../data/models/booking/booking_response.dart';
import '../../data/models/booking_availability/add_available_dates.dart';
import '../../data/models/booking_availability/available_dates_response.dart';
import '../../data/models/booking_availability/get_available_dates.dart';
import '../../data/models/booking_availability/get_upcoming_sat.dart';
import '../../data/models/booking_availability/set_available_dates.dart';
import '../../data/models/booking_details/booking_details_response.dart';
import '../../data/models/cancel_booking/cancel_booking_response.dart';
import '../../data/models/delete_booking/delete_booking_response.dart';
import '../../data/models/get_booking/get_booking_response.dart';
import '../../data/models/pay_booking/pay_booking_request.dart';
import '../../data/models/pay_booking/pay_booking_response.dart';
import '../../data/models/status_booking/status_booking_request.dart';
import '../../data/models/status_booking/status_booking_response.dart';
import '../../data/models/submit_review/submit_review_request.dart';
import '../../data/models/submit_review/submit_review_response.dart';
import '../../data/models/update_booking/update_booking_request.dart';
import '../../data/models/update_booking/update_booking_response.dart';

abstract class BookingRepository {
  Future<BookingResponse> bookSession(BookingRequest request);

  Future<StatusBookingResponse> statusBookSession(
      String id, StatusBookingRequest request);

  Future<CancelBookingResponse> cancelBookSession(String id);

  Future<UpdateBookingResponse> updateBookSession(
      String id, UpdateBookingRequest request);

  Future<DeleteBookingResponse> deleteBookSession(String id);

  Future<BookingDetailsResponse> getBookingDetails(String id);

  Future<GetBookingsResponse> getAllBookings(String status);

  Future<PayBookingResponse> payBooking(String id, PayBookingRequest request);

  Future<SubmitReviewResponse> submitReview(
      String id, SubmitReviewRequest body);

  Future<JoinSessionResponse> joinSession(String id);

  Future<GetUpcomingSat> getUpcomingSat();

  Future<AvailableDatesResponse> setAvailableDates(
    SetAvailableDates body,
  );

  Future<AvailableDatesResponse> addAvailableDates(AddAvailableDates body);

  Future<AvailableDatesResponse> deleteAvailableDate(String idOrDate);

  Future<GetAvailableDates> getAvailableDates(String instructorId);

  Future<AcceptedBookingsResponse> getAcceptedBookings();

  Future<Map<String, dynamic>> confirmPayment(String id);
}
