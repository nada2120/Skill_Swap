// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingErrorResponse _$BookingErrorResponseFromJson(
        Map<String, dynamic> json) =>
    BookingErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map(
              (e) => BookingValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookingErrorResponseToJson(
        BookingErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
