// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_booking_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusBookingErrorResponse _$StatusBookingErrorResponseFromJson(
        Map<String, dynamic> json) =>
    StatusBookingErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) =>
              StatusBookingValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatusBookingErrorResponseToJson(
        StatusBookingErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
