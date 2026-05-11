part of 'submit_review_bloc.dart';

@immutable
abstract class SubmitReviewState {}

class SubmitReviewInitial extends SubmitReviewState {}

class SubmitReviewLoading extends SubmitReviewState {}

class SubmitReviewSuccessState extends SubmitReviewState {
  final String message;

  SubmitReviewSuccessState(this.message);
}

class SubmitReviewFailureState extends SubmitReviewState {
  final SubmitReviewErrorResponse error;

  SubmitReviewFailureState(this.error);
}
