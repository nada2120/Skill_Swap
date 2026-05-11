import 'package:dio/dio.dart';
import 'package:skill_swap/shared/data/models/accepted_booking/accepted_booking_response.dart';
import 'package:skill_swap/shared/data/models/booking_availability/available_dates_response.dart';
import 'package:skill_swap/shared/data/models/booking_availability/get_available_dates.dart';
import 'package:skill_swap/shared/data/models/booking_availability/get_upcoming_sat.dart';
import 'package:skill_swap/shared/data/models/booking_availability/set_available_dates.dart';
import 'package:skill_swap/shared/data/models/join_session/join_session_response.dart';
import 'package:skill_swap/shared/data/models/submit_review/submit_review_success_response.dart';
import 'package:skill_swap/shared/domain/repositories/booking_repository.dart';

import '../models/booking/booking_error_response.dart';
import '../models/booking/booking_request.dart';
import '../models/booking/booking_response.dart';
import '../models/booking/booking_success_response.dart';
import '../models/booking_availability/add_available_dates.dart';
import '../models/booking_details/booking_details_error_response.dart';
import '../models/booking_details/booking_details_response.dart';
import '../models/booking_details/booking_details_success_response.dart';
import '../models/cancel_booking/cancel_booking_error_response.dart';
import '../models/cancel_booking/cancel_booking_response.dart';
import '../models/cancel_booking/cancel_booking_success_response.dart';
import '../models/delete_booking/delete_booking_error_response.dart';
import '../models/delete_booking/delete_booking_response.dart';
import '../models/delete_booking/delete_booking_success_response.dart';
import '../models/get_booking/get_booking_response.dart';
import '../models/pay_booking/pay_booking_error_response.dart';
import '../models/pay_booking/pay_booking_request.dart';
import '../models/pay_booking/pay_booking_response.dart';
import '../models/pay_booking/pay_booking_success_response.dart';
import '../models/status_booking/status_booking_error_response.dart';
import '../models/status_booking/status_booking_request.dart';
import '../models/status_booking/status_booking_response.dart';
import '../models/status_booking/status_booking_success_response.dart';
import '../models/submit_review/submit_review_error_response.dart';
import '../models/submit_review/submit_review_request.dart';
import '../models/submit_review/submit_review_response.dart';
import '../models/update_booking/update_booking_error_response.dart';
import '../models/update_booking/update_booking_request.dart';
import '../models/update_booking/update_booking_response.dart';
import '../models/update_booking/update_booking_success_response.dart';
import '../web_services/booking/booking_api.dart';

class BookingRepositoryImpl extends BookingRepository {
  final BookingApi api;
  final Dio dio;

  BookingRepositoryImpl({required this.api, required this.dio});

  String _getServerErrorMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        } else if (data is String) {
          return data;
        }
      }
    } catch (_) {}
    return e.message ?? "Network Error";
  }

  @override
  Future<BookingResponse> bookSession(BookingRequest request) async {
    try {
      final response = await api.bookSession(request);

      // بما إن response = Map<String,dynamic>
      if (response['message'] == 'Booking created successfully') {
        return BookingSuccess(
          BookingSuccessResponse.fromJson(response),
        );
      }

      return BookingFailure(
        BookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = BookingErrorResponse.fromJson(e.response!.data);
        return BookingFailure(error);
      }

      return BookingFailure(
        BookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return BookingFailure(
        BookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<StatusBookingResponse> statusBookSession(
      String id, StatusBookingRequest request) async {
    try {
      final response = await api.statusBookSession(id, request);

      if (response['message'] != null) {
        final msg = response['message'].toString().toLowerCase();

        if (msg.contains('updated') ||
            msg.contains('accepted') ||
            msg.contains('success')) {
          return StatusBookingSuccess(
            StatusBookingSuccessResponse.fromJson(response),
          );
        }
      }

      return StatusBookingFailure(
        StatusBookingErrorResponse.fromJson(response),
      );
    } catch (e) {
      return StatusBookingFailure(
        StatusBookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<CancelBookingResponse> cancelBookSession(String id) async {
    try {
      final response = await api.cancelBookSession(id);

      if (response['message'] == 'Booking canceled successfully') {
        return CancelBookingSuccess(
          CancelBookingSuccessResponse.fromJson(response),
        );
      }

      return CancelBookingFailure(
        CancelBookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = CancelBookingErrorResponse.fromJson(e.response!.data);
        return CancelBookingFailure(error);
      }

      return CancelBookingFailure(
        CancelBookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return CancelBookingFailure(
        CancelBookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<Map<String, dynamic>> confirmPayment(String id) async {
    try {
      final response = await api.confirmPayment(id);

      return Map<String, dynamic>.from(response);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(e.response!.data);
      }

      throw Exception(_getServerErrorMessage(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UpdateBookingResponse> updateBookSession(
      String id, UpdateBookingRequest request) async {
    try {
      final response = await api.updateBookSession(id, request);

      if (response['message'] == 'Booking updated successfully') {
        return UpdateBookingSuccess(
          UpdateBookingSuccessResponse.fromJson(response),
        );
      }

      return UpdateBookingFailure(
        UpdateBookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = UpdateBookingErrorResponse.fromJson(e.response!.data);
        return UpdateBookingFailure(error);
      }

      return UpdateBookingFailure(
        UpdateBookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return UpdateBookingFailure(
        UpdateBookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<GetBookingsResponse> getAllBookings(String status) async {
    try {
      final response = await api.getAllBookings(status);

      return GetBookingsResponse.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data != null && e.response!.data is Map<String, dynamic>
              ? e.response!.data['message']?.toString() ?? 'Server Error'
              : e.message ?? 'Network Error';
      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DeleteBookingResponse> deleteBookSession(String id) async {
    try {
      final response = await api.deleteBookSession(id) as Map<String, dynamic>;

      if (response['message'] == 'Booking deleted') {
        return DeleteBookingSuccess(
          DeleteBookingSuccessResponse.fromJson(response),
        );
      }

      return DeleteBookingFailure(
        DeleteBookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = DeleteBookingErrorResponse.fromJson(e.response!.data);
        return DeleteBookingFailure(error);
      }

      return DeleteBookingFailure(
        DeleteBookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return DeleteBookingFailure(
        DeleteBookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<BookingDetailsResponse> getBookingDetails(String id) async {
    try {
      final response = await api.getBookingDetails(id) as Map<String, dynamic>;

      return BookingDetailsSuccess(
        BookingDetailsSuccessResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = BookingDetailsErrorResponse.fromJson(e.response!.data);
        return BookingDetailsFailure(error);
      }

      return BookingDetailsFailure(
        BookingDetailsErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return BookingDetailsFailure(
        BookingDetailsErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<PayBookingResponse> payBooking(
      String id, PayBookingRequest request) async {
    try {
      final response = await api.payBooking(id, request);

      if (response['checkoutUrl'] != null) {
        return PayBookingSuccess(
          PayBookingSuccessResponse.fromJson(response),
        );
      }

      return PayBookingFailure(
        PayBookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = PayBookingErrorResponse.fromJson(e.response!.data);
        return PayBookingFailure(error);
      }

      return PayBookingFailure(
        PayBookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return PayBookingFailure(
        PayBookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<SubmitReviewResponse> submitReview(
      String id, SubmitReviewRequest request) async {
    try {
      final response = await api.submitReview(id, request);

      return SubmitReviewSuccess(
          success: SubmitReviewSuccessResponse.fromJson(response));
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = SubmitReviewErrorResponse.fromJson(e.response!.data);
        return SubmitReviewFailure(error: error);
      }

      return SubmitReviewFailure(
        error: SubmitReviewErrorResponse(
          message: _getServerErrorMessage(e),
        ),
      );
    } catch (e) {
      return SubmitReviewFailure(
        error: SubmitReviewErrorResponse(message: e.toString()),
      );
    }
  }

  String _extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is String) return data;
    } catch (_) {}
    return e.message ?? 'Network Error';
  }

  @override
  Future<JoinSessionResponse> joinSession(String id) async {
    try {
      final response = await api.joinSession(id);
      return JoinSessionResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<GetAvailableDates> getAvailableDates(String instructorId) async {
    try {
      final response = await api.getAvailableDates(instructorId);
      return GetAvailableDates.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<GetUpcomingSat> getUpcomingSat() async {
    try {
      final response = await api.getUpcomingSat();
      return GetUpcomingSat.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<AvailableDatesResponse> setAvailableDates(
      SetAvailableDates body) async {
    try {
      final response = await api.setAvailableDates(body);
      return AvailableDatesResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<AvailableDatesResponse> addAvailableDates(
      AddAvailableDates body) async {
    try {
      final response = await api.addAvailableDates(body);
      return AvailableDatesResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<AvailableDatesResponse> deleteAvailableDate(String idOrDate) async {
    try {
      final response = await api.deleteAvailableDate(idOrDate);
      return AvailableDatesResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<AcceptedBookingsResponse> getAcceptedBookings() async {
    try {
      final response = await api.getAcceptedBookings();
      return AcceptedBookingsResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }
}
