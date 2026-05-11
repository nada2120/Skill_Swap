import 'package:json_annotation/json_annotation.dart';
import 'package:skill_swap/shared/data/models/report_user/report_validation_error.dart';

part 'report_error_response.g.dart';

@JsonSerializable()
class ReportErrorResponse {
  final String message;
  final List<ReportValidationError>? validationErrors;

  ReportErrorResponse({required this.message, this.validationErrors});

  factory ReportErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReportErrorResponseToJson(this);
}
