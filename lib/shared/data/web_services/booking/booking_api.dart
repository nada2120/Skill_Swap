import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:skill_swap/shared/data/models/submit_review/submit_review_request.dart';

import '../../models/booking/booking_request.dart';
import '../../models/booking_availability/add_available_dates.dart';
import '../../models/booking_availability/set_available_dates.dart';
import '../../models/pay_booking/pay_booking_request.dart';
import '../../models/status_booking/status_booking_request.dart';
import '../../models/update_booking/update_booking_request.dart';

part 'booking_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/")
abstract class BookingApi {
  factory BookingApi(Dio dio, {String baseUrl}) = _BookingApi;

  @POST("booking/")
  Future<dynamic> bookSession(
    @Body() BookingRequest body,
  );

  @PATCH("booking/{id}/changeStatus")
  Future<dynamic> statusBookSession(
    @Path("id") String id,
    @Body() StatusBookingRequest body,
  );

  @PATCH("booking/{id}/cancel")
  Future<dynamic> cancelBookSession(
    @Path("id") String id,
  );

  @PATCH("booking/{id}/confirm-payment")
  Future<dynamic> confirmPayment(
    @Path("id") String id,
  );

  @PATCH("booking/{id}")
  Future<dynamic> updateBookSession(
    @Path("id") String id,
    @Body() UpdateBookingRequest body,
  );

  @DELETE("booking/{id}")
  Future<dynamic> deleteBookSession(
    @Path("id") String id,
  );

  @GET("booking/{id}")
  Future<dynamic> getBookingDetails(
    @Path("id") String id,
  );

  @GET("booking/user")
  Future<dynamic> getAllBookings(@Query('status') String status);

  @POST("booking/{id}/pay")
  Future<dynamic> payBooking(
    @Path("id") String id,
    @Body() PayBookingRequest body,
  );

  @PATCH("booking/{id}/complete")
  Future<dynamic> submitReview(
    @Path("id") String id,
    @Body() SubmitReviewRequest body,
  );

  @PATCH("booking/{id}/join")
  Future<dynamic> joinSession(
    @Path("id") String id,
  );

  @GET("booking/saturdays")
  Future<dynamic> getUpcomingSat();

  @POST("booking/availability")
  Future<dynamic> setAvailableDates(
    @Body() SetAvailableDates body,
  );

  @GET("booking/availability/{instructorId}")
  Future<dynamic> getAvailableDates(
    @Path("instructorId") String instructorId,
  );

  @POST("booking/availability/add")
  Future<dynamic> addAvailableDates(
    @Body() AddAvailableDates body,
  );

  @DELETE("booking/availability/{idOrDate}")
  Future<dynamic> deleteAvailableDate(
    @Path("idOrDate") String idOrDate,
  );

  @GET("booking/accepted")
  Future<dynamic> getAcceptedBookings();
}
