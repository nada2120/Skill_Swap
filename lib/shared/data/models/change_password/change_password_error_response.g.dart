// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordErrorResponse _$ChangePasswordErrorResponseFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) =>
              ChangePasswordValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChangePasswordErrorResponseToJson(
        ChangePasswordErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
