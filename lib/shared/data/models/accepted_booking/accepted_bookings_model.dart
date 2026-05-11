import '../get_booking/user_id.dart';

class AcceptedBookingsModel {
  final String id;

  final UserBooking student;
  final UserBooking instructor;

  final DateTime date;
  final String time;
  final num durationMins;
  final num price;

  final String bookingCode;
  final String status;
  final String paymentStatus;

  final String? stripeSessionId;

  final num rate;
  final String review;
  final bool isRated;

  final bool studentJoined;
  final bool instructorJoined;

  final bool reminderSent;
  final bool ratingRequestSent;

  final DateTime createdAt;
  final DateTime updatedAt;

  final num version;

  AcceptedBookingsModel({
    required this.id,
    required this.student,
    required this.instructor,
    required this.date,
    required this.time,
    required this.durationMins,
    required this.price,
    required this.bookingCode,
    required this.status,
    required this.paymentStatus,
    this.stripeSessionId,
    required this.rate,
    required this.review,
    required this.isRated,
    required this.studentJoined,
    required this.instructorJoined,
    required this.reminderSent,
    required this.ratingRequestSent,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory AcceptedBookingsModel.fromJson(Map<String, dynamic>? json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return AcceptedBookingsModel(
      id: json?['_id'] ?? '',
      student: UserBooking.fromJson(json?['studentId']),
      instructor: UserBooking.fromJson(json?['instructorId']),
      date: DateTime.parse(json?['date']),
      time: json?['time'] ?? '',
      durationMins: json?['duration_mins'] ?? 0,
      price: json?['price'] ?? 0,
      bookingCode: json?['bookingCode'] ?? '',
      status: json?['status'] ?? '',
      paymentStatus: json?['paymentStatus'] ?? '',
      stripeSessionId: json?['stripeSessionId'],
      rate: parseDouble(json?['rate']),
      review: json?['review'] ?? '',
      isRated: json?['isRated'] ?? false,
      studentJoined: json?['studentJoined'] ?? false,
      instructorJoined: json?['instructorJoined'] ?? false,
      reminderSent: json?['reminderSent'] ?? false,
      ratingRequestSent: json?['ratingRequestSent'] ?? false,
      createdAt: DateTime.parse(json?['createdAt']),
      updatedAt: DateTime.parse(json?['updatedAt']),
      version: json?['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "studentId": student.toJson(),
      "instructorId": instructor.toJson(),
      "date": date.toIso8601String(),
      "time": time,
      "duration_mins": durationMins,
      "price": price,
      "bookingCode": bookingCode,
      "status": status,
      "paymentStatus": paymentStatus,
      "stripeSessionId": stripeSessionId,
      "rate": rate,
      "review": review,
      "isRated": isRated,
      "studentJoined": studentJoined,
      "instructorJoined": instructorJoined,
      "reminderSent": reminderSent,
      "ratingRequestSent": ratingRequestSent,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "__v": version,
    };
  }
}
