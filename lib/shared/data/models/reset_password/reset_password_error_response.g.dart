// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordErrorResponse _$ResetPasswordErrorResponseFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) =>
              ResetPasswordValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResetPasswordErrorResponseToJson(
        ResetPasswordErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
