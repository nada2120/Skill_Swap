import 'package:json_annotation/json_annotation.dart';

import 'status_booking_validation_error.dart';

part 'status_booking_error_response.g.dart';

@JsonSerializable()
class StatusBookingErrorResponse {
  final String message;
  final List<StatusBookingValidationError>? validationErrors;

  StatusBookingErrorResponse({required this.message, this.validationErrors});

  factory StatusBookingErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusBookingErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatusBookingErrorResponseToJson(this);
}
