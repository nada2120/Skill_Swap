import 'package:json_annotation/json_annotation.dart';

import 'update_booking_validation_error.dart';

part 'update_booking_error_response.g.dart';

@JsonSerializable()
class UpdateBookingErrorResponse {
  final String message;
  final List<UpdateBookingValidationError>? validationErrors;

  UpdateBookingErrorResponse({required this.message, this.validationErrors});

  factory UpdateBookingErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateBookingErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBookingErrorResponseToJson(this);
}
