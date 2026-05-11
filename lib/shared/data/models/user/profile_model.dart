import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String bio;
  final String skillSummary;
  final int reputationScore;
  final String lastUpdated;

  Profile({
    required this.bio,
    required this.skillSummary,
    required this.reputationScore,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        bio,
        skillSummary,
        reputationScore,
        lastUpdated,
      ];

  factory Profile.fromJson(Map<String, dynamic>? json) {
    return Profile(
      bio: json?['bio'] ?? '',
      skillSummary: json?['skillSummary'] ?? '',
      reputationScore: json?['reputationScore'] ?? 0,
      lastUpdated: json?['lastUpdated'] ?? '',
    );
  }

  factory Profile.empty() {
    return Profile(
        bio: "", skillSummary: "", reputationScore: 0, lastUpdated: "");
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'skillSummary': skillSummary,
      'reputationScore': reputationScore,
      'lastUpdated': lastUpdated
    };
  }
}
