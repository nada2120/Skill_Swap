import 'package:json_annotation/json_annotation.dart';

part 'report_validation_error.g.dart';

@JsonSerializable()
class ReportValidationError {
  final String field;
  final String message;

  ReportValidationError({required this.field, required this.message});

  factory ReportValidationError.fromJson(Map<String, dynamic> json) =>
      _$ReportValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ReportValidationErrorToJson(this);
}
