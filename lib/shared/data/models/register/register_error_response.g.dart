// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterErrorResponse _$RegisterErrorResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) =>
              RegisterValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegisterErrorResponseToJson(
        RegisterErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
