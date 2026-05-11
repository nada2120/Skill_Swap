import 'package:cloud_firestore/cloud_firestore.dart';

class CallService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createCall({
    required String roomId,
    required String callerId,
    required String receiverId,
  }) async {
    await firestore.collection("calls").doc(roomId).set({
      "roomId": roomId,
      "callerId": callerId,
      "receiverId": receiverId,
      "status": "ringing",
      "studentJoined": false,
      "instructorJoined": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> markUserJoined({
    required String roomId,
    required bool isStudent,
  }) async {
    await firestore.collection("calls").doc(roomId).update({
      if (isStudent) "studentJoined": true,
      if (!isStudent) "instructorJoined": true,
    });
  }

  Future<void> acceptCall(String roomId) async {
    await firestore.collection("calls").doc(roomId).update({
      "status": "accepted",
    });
  }

  Future<void> endCall(String roomId) async {
    await firestore.collection("calls").doc(roomId).update({
      "status": "ended",
    });
  }

  Stream<DocumentSnapshot> listenCall(String roomId) {
    return firestore.collection("calls").doc(roomId).snapshots();
  }
}
