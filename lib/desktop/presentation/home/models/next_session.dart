class NextSession {
  final String image;
  final String name;
  final String dateTime;
  final String duration;
  final String startsIn;
  final bool isMentor;

  NextSession({
    required this.image,
    required this.name,
    required this.dateTime,
    required this.duration,
    required this.startsIn,
    this.isMentor = true,
  });

  factory NextSession.fromJson(Map<String, dynamic> json) {
    return NextSession(
      image: json['image'] ?? '',
      name: json['name'],
      dateTime: json['date_time'],
      duration: json['duration'],
      startsIn: json['starts_in'],
      isMentor: json['is_mentor'] ?? true,
    );
  }
}