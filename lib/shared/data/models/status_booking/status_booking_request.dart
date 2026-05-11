import 'package:json_annotation/json_annotation.dart';

part 'status_booking_request.g.dart';

@JsonSerializable()
class StatusBookingRequest {
  final String status;

  StatusBookingRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() => _$StatusBookingRequestToJson(this);
}
