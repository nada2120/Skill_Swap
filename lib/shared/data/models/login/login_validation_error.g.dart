// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginValidationError _$LoginValidationErrorFromJson(
        Map<String, dynamic> json) =>
    LoginValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$LoginValidationErrorToJson(
        LoginValidationError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
    };
