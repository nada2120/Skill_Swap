import 'package:json_annotation/json_annotation.dart';

part 'update_booking_request.g.dart';

@JsonSerializable()
class UpdateBookingRequest {
  final String time;
  final String date;
  final num duration_mins;

  UpdateBookingRequest({
    required this.time,
    required this.date,
    required this.duration_mins,
  });

  Map<String, dynamic> toJson() => _$UpdateBookingRequestToJson(this);
}
