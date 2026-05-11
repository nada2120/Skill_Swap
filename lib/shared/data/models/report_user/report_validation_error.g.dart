// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportValidationError _$ReportValidationErrorFromJson(
        Map<String, dynamic> json) =>
    ReportValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ReportValidationErrorToJson(
        ReportValidationError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
    };
