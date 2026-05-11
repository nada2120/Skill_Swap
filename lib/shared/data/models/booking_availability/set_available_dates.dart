class SetAvailableDates {
  final List<Dates> availableDates;
  final String rotationType;

  SetAvailableDates({
    required this.availableDates,
    required this.rotationType,
  });

  factory SetAvailableDates.fromJson(Map<String, dynamic> json) {
    return SetAvailableDates(
      availableDates: (json['availableDates'] as List<dynamic>?)
              ?.map((e) => Dates.fromJson(e))
              .toList() ??
          [],
      rotationType: json['rotationType'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'availableDates': availableDates.map((e) => e.toJson()).toList(),
        'rotationType': rotationType,
      };
}

class Dates {
  final String date;
  final String from;
  final String to;

  Dates({
    required this.date,
    required this.from,
    required this.to,
  });

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      date: json['date'] ?? "",
      from: json['from'] ?? "",
      to: json['to'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'from': from,
        'to': to,
      };
}
