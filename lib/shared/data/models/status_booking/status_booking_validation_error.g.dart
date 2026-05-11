// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_booking_validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusBookingValidationError _$StatusBookingValidationErrorFromJson(
        Map<String, dynamic> json) =>
    StatusBookingValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$StatusBookingValidationErrorToJson(
        StatusBookingValidationError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
    };
