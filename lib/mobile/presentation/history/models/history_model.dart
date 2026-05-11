class HistoryModel {
  final String id;
  final String name;
  final String role;
  final String date;
  final String time;
  final String duration;
  final String status;
  final double rating;
  final String? errorMessage;
  final String imageUrl;
  final String? reviewComment;
  final bool isReviewReceived;

  HistoryModel(
      {required this.id,
      required this.name,
      required this.role,
      required this.date,
      required this.time,
      required this.duration,
      required this.status,
      required this.rating,
      required this.imageUrl,
      this.errorMessage,
      this.reviewComment,
      this.isReviewReceived = false});
}
