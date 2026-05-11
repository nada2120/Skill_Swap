class AvailableDates {
  final String date;
  final String from;
  final String to;
  final String id;

  AvailableDates(
      {required this.date,
      required this.from,
      required this.to,
      required this.id});

  factory AvailableDates.fromJson(Map<String, dynamic> json) {
    return AvailableDates(
        date: json['date'] ?? "",
        from: json['from'] ?? "",
        to: json['to'] ?? "",
        id: json['_id'] ?? "");
  }

  Map<String, dynamic> toJson() =>
      {'date': date, 'from': from, 'to': to, '_id': id};
}
