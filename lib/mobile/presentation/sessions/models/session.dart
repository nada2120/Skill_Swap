class SessionModel {
  final String sessionId;
  final String userId;
  final String studentId;
  final String userImage;
  final String userName;
  final String userRole;
  final DateTime dateTime;
  final num duration;
  final num price;
  final String status;
  final String rawStatus;
  final DateTime timeAgo;
  final String bookingCode;
  final bool isStudent;
  final String paymentStatus;
  final bool studentJoined;
  final bool instructorJoined;

  // final DateTime createAt;

  SessionModel(
      {required this.sessionId,
      required this.userId,
      required this.studentId,
      required this.userImage,
      required this.userName,
      required this.userRole,
      required this.dateTime,
      required this.price,
      required this.status,
      required this.rawStatus,
      required this.timeAgo,
      required this.bookingCode,
      required this.isStudent,
      required this.duration,
      required this.instructorJoined,
      required this.studentJoined,
      required this.paymentStatus});

  SessionModel copyWith({
    String? status,
    String? rawStatus,
  }) {
    return SessionModel(
        sessionId: sessionId,
        bookingCode: bookingCode,
        userId: userId,
        instructorJoined: instructorJoined,
        studentJoined: studentJoined,
        studentId: studentId,
        userName: userName,
        userRole: userRole,
        userImage: userImage,
        dateTime: dateTime,
        price: price,
        status: status ?? this.status,
        rawStatus: rawStatus ?? this.rawStatus,
        timeAgo: timeAgo,
        isStudent: isStudent,
        duration: duration,
        paymentStatus: paymentStatus);
  }
}
