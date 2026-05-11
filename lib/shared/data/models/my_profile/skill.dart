import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  final String skillName;
  final bool isVerified;
  final int quizScore;
  final String _id;
  final String addedAt;

  Skill(
      {required this.skillName,
      required this.isVerified,
      required this.quizScore,
      required String id,
      required this.addedAt})
      : _id = id;

  @override
  List<Object?> get props => [skillName, isVerified, _id, quizScore, addedAt];

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
        skillName: json['skillName'] ?? '',
        isVerified: json['isVerified'] ?? false,
        quizScore: json['quizScore'] ?? 0,
        id: json['_id'] ?? "",
        addedAt: json['addedAt'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'isVerified': isVerified,
      'quizScore': quizScore,
      '_id': _id,
      'addedAt': addedAt
    };
  }

  factory Skill.empty() {
    return Skill(
        skillName: "", isVerified: false, quizScore: 0, id: "", addedAt: "");
  }
}
