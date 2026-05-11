import 'package:json_annotation/json_annotation.dart';
import 'package:skill_swap/shared/data/models/submit_review/submit_review_validation_error.dart';

part 'submit_review_error_response.g.dart';

@JsonSerializable()
class SubmitReviewErrorResponse {
  final String message;
  final List<SubmitReviewValidationError>? validationErrors;

  SubmitReviewErrorResponse({required this.message, this.validationErrors});

  factory SubmitReviewErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitReviewErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitReviewErrorResponseToJson(this);
}
