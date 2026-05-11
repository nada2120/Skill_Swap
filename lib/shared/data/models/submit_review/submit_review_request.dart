import 'package:json_annotation/json_annotation.dart';

part 'submit_review_request.g.dart';

@JsonSerializable()
class SubmitReviewRequest {
  final int rate;
  final String review;

  SubmitReviewRequest({
    required this.rate,
    required this.review,
  });

  Map<String, dynamic> toJson() => _$SubmitReviewRequestToJson(this);
}
