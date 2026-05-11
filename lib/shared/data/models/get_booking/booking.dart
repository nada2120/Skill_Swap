import 'package:skill_swap/shared/data/models/get_booking/user_id.dart';

import '../../../core/utils/id_normalizer.dart';

class GetBookingModel {
  final String id;
  final UserBooking studentId;
  final UserBooking instructorId;

  final DateTime date;
  final String time;
  final num durationMins;
  final num price;
  final String bookingCode;
  final String status;
  final num rate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final num v;

  final String paymentStatus;
  final String? stripeSessionId;
  final String review;
  final bool isRated;
  final bool studentJoined;
  final bool instructorJoined;
  final bool reminderSent;
  final bool ratingRequestSent;

  GetBookingModel({
    required this.id,
    required this.studentId,
    required this.instructorId,
    required this.date,
    required this.time,
    required this.durationMins,
    required this.price,
    required this.bookingCode,
    required this.status,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.paymentStatus,
    required this.stripeSessionId,
    required this.review,
    required this.isRated,
    required this.studentJoined,
    required this.instructorJoined,
    required this.reminderSent,
    required this.ratingRequestSent,
  });

  factory GetBookingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception("GetBookingModel json is null");
    }

    DateTime safeDate(dynamic value) {
      if (value == null) return DateTime.now();
      return DateTime.tryParse(value.toString()) ?? DateTime.now();
    }

    return GetBookingModel(
      id: IdNormalizer.normalize(json['_id']),
      studentId: json['studentId'] != null
          ? UserBooking.fromJson(json['studentId'])
          : UserBooking.empty(),
      instructorId: json['instructorId'] != null
          ? UserBooking.fromJson(json['instructorId'])
          : UserBooking.empty(),
      date: safeDate(json['date']),
      time: json['time']?.toString() ?? '',
      durationMins: json['duration_mins'] ?? 0,
      price: json['price'] ?? 0,
      bookingCode: json['bookingCode'] ?? '',
      status: json['status'] ?? '',
      rate: json['rate'] ?? 0,
      createdAt: safeDate(json['createdAt']),
      updatedAt: safeDate(json['updatedAt']),
      v: json['__v'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? '',
      stripeSessionId: json['stripeSessionId']?.toString(),
      review: json['review'] ?? '',
      isRated: json['isRated'] ?? false,
      studentJoined: json['studentJoined'] ?? false,
      instructorJoined: json['instructorJoined'] ?? false,
      reminderSent: json['reminderSent'] ?? false,
      ratingRequestSent: json['ratingRequestSent'] ?? false,
    );
  }
}
