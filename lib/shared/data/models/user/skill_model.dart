import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  final String skillName;
  final bool isVerified;
  final int quizScore;
  final String id;
  final String addedAt;

  Skill({
    required this.skillName,
    required this.isVerified,
    required this.id,
    required this.quizScore,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [skillName, isVerified, id, quizScore, addedAt];

  factory Skill.fromJson(Map<String, dynamic>? json) {
    return Skill(
      skillName: json?['skillName'] ?? '',
      isVerified: json?['isVerified'] ?? false,
      id: json?['_id'] ?? "",
      quizScore: json?['quizScore'] ?? 0,
      addedAt: json?['addedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'isVerified': isVerified,
      '_id': id,
      'quizScore': quizScore,
      'addedAt': addedAt,
    };
  }
}
