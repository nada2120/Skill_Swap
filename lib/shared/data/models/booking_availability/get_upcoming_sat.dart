class GetUpcomingSat {
  final String message;
  final String date;

  GetUpcomingSat({
    required this.message,
    required this.date,
  });

  factory GetUpcomingSat.fromJson(Map<String, dynamic> json) {
    return GetUpcomingSat(
      message: json['message'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
