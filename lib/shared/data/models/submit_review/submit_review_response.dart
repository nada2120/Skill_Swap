import 'package:skill_swap/shared/data/models/submit_review/submit_review_error_response.dart';
import 'package:skill_swap/shared/data/models/submit_review/submit_review_success_response.dart';

sealed class SubmitReviewResponse {}

class SubmitReviewSuccess extends SubmitReviewResponse {
  final SubmitReviewSuccessResponse success;

  SubmitReviewSuccess({required this.success});
}

class SubmitReviewFailure extends SubmitReviewResponse {
  final SubmitReviewErrorResponse error;

  SubmitReviewFailure({required this.error});
}
