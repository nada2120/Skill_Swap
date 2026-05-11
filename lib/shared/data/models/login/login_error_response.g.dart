// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginErrorResponse _$LoginErrorResponseFromJson(Map<String, dynamic> json) =>
    LoginErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) => LoginValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LoginErrorResponseToJson(LoginErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
