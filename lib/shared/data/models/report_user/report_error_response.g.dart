// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportErrorResponse _$ReportErrorResponseFromJson(Map<String, dynamic> json) =>
    ReportErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map(
              (e) => ReportValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportErrorResponseToJson(
        ReportErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
