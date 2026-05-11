import 'available_dates.dart';

class AvailableDatesResponse {
  final String message;
  final Availability data;

  AvailableDatesResponse({required this.message, required this.data});

  factory AvailableDatesResponse.fromJson(Map<String, dynamic> json) {
    return AvailableDatesResponse(
      message: json['message'],
      data: Availability.fromJson(json['availability']),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'message': message,
        'availability': data.toJson(),
      };
}

class Availability {
  final String id;
  final String instructorId;
  final List<AvailableDates> availableDates;
  final String rotationType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Availability({
    required this.id,
    required this.instructorId,
    required this.availableDates,
    required this.createdAt,
    required this.updatedAt,
    required this.rotationType,
    required this.v,
  });

  factory Availability.fromJson(Map<String, dynamic> json) =>
      Availability(
        id: json['_id'],
        instructorId: json['instructorId'],
        availableDates: (json['availableDates'] as List)
            .map((e) => AvailableDates.fromJson(e))
            .toList(),
        rotationType: json['rotationType'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() =>
      {
        '_id': id,
        'instructorId': instructorId,
        'availableDates': availableDates,
        'rotationType': rotationType,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}
