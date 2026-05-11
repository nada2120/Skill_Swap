import '../../../core/utils/id_normalizer.dart';

class Booking {
  final String studentId;
  final String instructorId;

  final DateTime date;
  final String time;
  final num duration_mins;
  final num price;
  final String bookingCode;
  final String status;
  final num rate;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final num v;

  Booking(
      {required this.id,
      required this.studentId,
      required this.instructorId,
      required this.date,
      required this.time,
      required this.duration_mins,
      required this.price,
      required this.bookingCode,
      required this.status,
      required this.rate,
      required this.createdAt,
      required this.updatedAt,
      required this.v});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: IdNormalizer.normalize(json['_id']),
      studentId: IdNormalizer.normalize(json['studentId']),
      instructorId: IdNormalizer.normalize(json['instructorId']),
      date: DateTime.parse(json['date']),
      time: json['time'],
      duration_mins: json['duration_mins'],
      price: json['price'],
      bookingCode: json['bookingCode'],
      status: json['status'],
      rate: json['rate'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'instructorId': instructorId,
      'date': date.toIso8601String(),
      'time': time,
      'duration_mins': duration_mins,
      'price': price,
      'bookingCode': bookingCode,
      'status': status,
      'rate': rate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v
    };
  }
}
