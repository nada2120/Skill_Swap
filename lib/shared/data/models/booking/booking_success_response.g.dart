// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingSuccessResponse _$BookingSuccessResponseFromJson(
        Map<String, dynamic> json) =>
    BookingSuccessResponse(
      message: json['message'] as String,
      bookSession: Booking.fromJson(json['booking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingSuccessResponseToJson(
        BookingSuccessResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'booking': instance.bookSession,
    };
