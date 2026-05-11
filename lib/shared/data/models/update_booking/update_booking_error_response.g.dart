// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_booking_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBookingErrorResponse _$UpdateBookingErrorResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateBookingErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) =>
              UpdateBookingValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdateBookingErrorResponseToJson(
        UpdateBookingErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
