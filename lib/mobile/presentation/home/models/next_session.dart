import 'dart:ui';

class NextSession {
  final String name;
  final DateTime sessionTime;
  final String dateTime;
  final String duration;
  final bool isMentor;
  final VoidCallback? onTap;

  //final int remainingMinutes;

  NextSession(
      {required this.name,
      required this.dateTime,
      required this.duration,
      required this.sessionTime,
      this.isMentor = true,
      this.onTap});

  factory NextSession.fromJson(Map<String, dynamic> json) {
    return NextSession(
        name: json['name'],
        dateTime: json['date_time'],
        duration: json['duration'],
        sessionTime: json['session_time'],
        isMentor: json['is_mentor'] ?? true,
        onTap: null);
  }
}
