import 'available_dates.dart';

class GetAvailableDates {
  final String message;
  final List<AvailableDates> availableDates;

  GetAvailableDates({
    required this.message,
    required this.availableDates,
  });

  factory GetAvailableDates.fromJson(Map<String, dynamic> json) {
    return GetAvailableDates(
      message: json['message'] ?? '',
      availableDates: (json['availableDates'] as List? ?? [])
          .map((e) => AvailableDates.fromJson(e))
          .toList(),
    );
  }

  GetAvailableDates copyWith(
      {String? message, List<AvailableDates>? availableDates}) {
    return GetAvailableDates(
      message: message ?? this.message,
      availableDates: availableDates ?? this.availableDates,
    );
  }
}
