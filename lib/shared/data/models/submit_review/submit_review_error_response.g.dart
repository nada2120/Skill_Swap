// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_review_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitReviewErrorResponse _$SubmitReviewErrorResponseFromJson(
        Map<String, dynamic> json) =>
    SubmitReviewErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) =>
              SubmitReviewValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmitReviewErrorResponseToJson(
        SubmitReviewErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
