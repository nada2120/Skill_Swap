class AddAvailableDates {
  final String date;
  final String from;
  final String to;
  final String rotationType;

  AddAvailableDates(
      {required this.date,
      required this.from,
      required this.to,
      required this.rotationType});

  factory AddAvailableDates.fromJson(Map<String, dynamic> json) {
    return AddAvailableDates(
        date: json['date'] ?? "",
        from: json['from'] ?? "",
        to: json['to'] ?? "",
        rotationType: json['rotationType'] ?? '');
  }

  Map<String, dynamic> toJson() =>
      {'date': date, 'from': from, 'to': to, 'rotationType': rotationType};
}
