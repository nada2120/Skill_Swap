// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitReviewRequest _$SubmitReviewRequestFromJson(Map<String, dynamic> json) =>
    SubmitReviewRequest(
      rate: (json['rate'] as num).toInt(),
      review: json['review'] as String,
    );

Map<String, dynamic> _$SubmitReviewRequestToJson(
        SubmitReviewRequest instance) =>
    <String, dynamic>{
      'rate': instance.rate,
      'review': instance.review,
    };
