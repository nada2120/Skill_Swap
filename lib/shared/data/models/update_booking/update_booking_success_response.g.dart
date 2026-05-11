// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_booking_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBookingSuccessResponse _$UpdateBookingSuccessResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateBookingSuccessResponse(
      message: json['message'] as String,
      bookSession: Booking.fromJson(json['booking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateBookingSuccessResponseToJson(
        UpdateBookingSuccessResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'booking': instance.bookSession,
    };
