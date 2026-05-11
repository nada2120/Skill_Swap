class Booking {
  final String id;
  final String userId;
  final DateTime date;
  final String time;
  final int durationMins;
  final int price;
  final String bookingCode;
  final String status;
  final int rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.date,
    required this.time,
    required this.durationMins,
    required this.price,
    required this.bookingCode,
    required this.status,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      durationMins: json['duration_mins'],
      price: json['price'],
      bookingCode: json['bookingCode'],
      status: json['status'],
      rate: json['rate'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'time': time,
      'duration_mins': durationMins,
      'price': price,
      'bookingCode': bookingCode,
      'status': status,
      'rate': rate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
