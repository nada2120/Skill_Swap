part of 'submit_review_bloc.dart';

@immutable
abstract class SubmitReviewEvent {}

// submit normal review
class ConfirmSubmit extends SubmitReviewEvent {
  final String id;
  final SubmitReviewRequest request;

  ConfirmSubmit({
    required this.id,
    required this.request,
  });
}
