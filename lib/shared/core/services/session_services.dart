import 'package:cloud_firestore/cloud_firestore.dart';

class SessionService {
  static Future<Map<String, dynamic>> createSession({
    required String bookingCode,
    required int minutes,
  }) async {
    final roomId = "${bookingCode}_${DateTime.now().millisecondsSinceEpoch}";

    await FirebaseFirestore.instance
        .collection("sessions")
        .doc(bookingCode)
        .set({
      "roomId": roomId,
      "status": "active",
      "endTime": Timestamp.fromDate(
        DateTime.now().add(Duration(minutes: minutes)),
      ),
    });

    return {
      "sessionId": bookingCode,
      "roomId": roomId,
    };
  }
}
