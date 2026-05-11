// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterValidationError _$RegisterValidationErrorFromJson(
        Map<String, dynamic> json) =>
    RegisterValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$RegisterValidationErrorToJson(
        RegisterValidationError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
    };
