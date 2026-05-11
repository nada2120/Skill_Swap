import 'package:json_annotation/json_annotation.dart';

part 'submit_review_validation_error.g.dart';

@JsonSerializable()
class SubmitReviewValidationError {
  final String field;
  final String message;

  SubmitReviewValidationError({required this.field, required this.message});

  factory SubmitReviewValidationError.fromJson(Map<String, dynamic> json) =>
      _$SubmitReviewValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitReviewValidationErrorToJson(this);
}
