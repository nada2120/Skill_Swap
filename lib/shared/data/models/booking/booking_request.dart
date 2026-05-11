import 'package:json_annotation/json_annotation.dart';

part 'booking_request.g.dart';

@JsonSerializable()
class BookingRequest {
  final String instructorId;
  final String time;
  final String date;
  final num duration_mins;
  final bool isFree;

  BookingRequest(
      {required this.time,
      required this.date,
      required this.duration_mins,
      required this.instructorId,
      required this.isFree});

  Map<String, dynamic> toJson() => _$BookingRequestToJson(this);
}
