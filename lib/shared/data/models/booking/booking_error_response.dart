import 'package:json_annotation/json_annotation.dart';

import 'booking_validation_error.dart';

part 'booking_error_response.g.dart';

@JsonSerializable()
class BookingErrorResponse {
  final String message;
  final List<BookingValidationError>? validationErrors;

  BookingErrorResponse({required this.message, this.validationErrors});

  factory BookingErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingErrorResponseToJson(this);
}
