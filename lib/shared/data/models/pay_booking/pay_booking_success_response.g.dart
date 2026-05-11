// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_booking_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayBookingSuccessResponse _$PayBookingSuccessResponseFromJson(
        Map<String, dynamic> json) =>
    PayBookingSuccessResponse(
      message: json['message'] as String,
      checkoutUrl: json['checkoutUrl'] as String,
      sessionId: json['sessionId'] as String?,
    );

Map<String, dynamic> _$PayBookingSuccessResponseToJson(
        PayBookingSuccessResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'checkoutUrl': instance.checkoutUrl,
      'sessionId': instance.sessionId,
    };
