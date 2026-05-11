// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingValidationError _$BookingValidationErrorFromJson(
        Map<String, dynamic> json) =>
    BookingValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$BookingValidationErrorToJson(
        BookingValidationError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
    };
