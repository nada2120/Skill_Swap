part 'submit_review_success_response.g.dart';

class SubmitReviewSuccessResponse {
  final String message;

  SubmitReviewSuccessResponse({required this.message});

  factory SubmitReviewSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitReviewSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitReviewSuccessResponseToJson(this);
}
