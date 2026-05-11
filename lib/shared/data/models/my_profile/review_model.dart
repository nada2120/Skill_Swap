import 'reviewer_model.dart';

class ReviewModel {
  final num rating;
  final String review;
  final Reviewer reviewer;
  final String id;
  final DateTime createdAt;

  ReviewModel({
    required this.rating,
    required this.review,
    required this.reviewer,
    required this.id,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      reviewer: json['reviewer'] != null
          ? Reviewer.fromJson(json['reviewer'])
          : Reviewer.empty(),
      id: json['_id'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'review': review,
      'reviewer': reviewer.toJson(),
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
