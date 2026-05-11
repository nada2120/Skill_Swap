// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRequest _$BookingRequestFromJson(Map<String, dynamic> json) =>
    BookingRequest(
      time: json['time'] as String,
      date: json['date'] as String,
      duration_mins: json['duration_mins'] as num,
      instructorId: json['instructorId'] as String,
      isFree: json['isFree'] as bool,
    );

Map<String, dynamic> _$BookingRequestToJson(BookingRequest instance) =>
    <String, dynamic>{
      'instructorId': instance.instructorId,
      'time': instance.time,
      'date': instance.date,
      'duration_mins': instance.duration_mins,
      'isFree': instance.isFree,
    };
