import 'package:equatable/equatable.dart';
import 'package:skill_swap/shared/data/models/my_profile/Blocked_me.dart';

import '../user/profile_model.dart';
import '../user/skill_model.dart';
import '../user/track_model.dart';
import '../user/usesr_image.dart';
import 'active_theme.dart';
import 'review_model.dart';

class MyProfile extends Equatable {
  final UserImage userImage;
  final Profile profile;
  final BlockedMe blockInfo;
  final Track track;

  final String id;
  final String name;
  final String email;

  final bool isActive;
  final String role;

  final ActiveTheme? activeTheme;

  /// 🔥 nullable numbers
  final num? rate;
  final num? totalScore;
  final num? wallet;
  final num? numberOfReviews;
  final num? score;
  final num? varPoints;
  final num? points;
  final num? freeHours;
  final num? helpTotalHours;
  final num? warningCount;
  final num? v;
  final num? hourlyPrice;

  final String? activationCode;
  final DateTime? activationCodeExpires;
  final String fcmToken;

  final List<Skill> skills;
  final List<ReviewModel> reviews;

  final List<dynamic> messages;
  final List<dynamic> reports;
  final List<dynamic> requests;
  final List<dynamic> feedbackGiven;
  final List<dynamic> feedbackReceived;
  final List<dynamic> mentorSuggestions;
  final List<dynamic> challenges;
  final List<dynamic> warnings;
  final List<dynamic> purchasedThemes;

  final DateTime createdAt;
  final DateTime updatedAt;

  const MyProfile({
    required this.userImage,
    required this.profile,
    required this.blockInfo,
    required this.track,
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    required this.role,
    required this.activeTheme,
    required this.rate,
    required this.totalScore,
    required this.wallet,
    required this.numberOfReviews,
    required this.score,
    required this.varPoints,
    required this.points,
    required this.freeHours,
    required this.helpTotalHours,
    required this.warningCount,
    required this.v,
    required this.hourlyPrice,
    required this.activationCode,
    required this.activationCodeExpires,
    required this.fcmToken,
    required this.skills,
    required this.reviews,
    required this.messages,
    required this.reports,
    required this.requests,
    required this.feedbackGiven,
    required this.feedbackReceived,
    required this.mentorSuggestions,
    required this.challenges,
    required this.warnings,
    required this.purchasedThemes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) {
      if (value == null || value.isEmpty) return null;
      return DateTime.tryParse(value);
    }

    return MyProfile(
      /// OBJECTS
      userImage: json['userImage'] != null
          ? UserImage.fromJson(json['userImage'])
          : UserImage.empty(),

      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'])
          : Profile.empty(),

      track:
          json['track'] != null ? Track.fromJson(json['track']) : Track.empty(),

      blockInfo: json['blockInfo'] != null
          ? BlockedMe.fromJson(json['blockInfo'])
          : BlockedMe.empty(),

      /// BASIC
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? false,
      role: json['role'] ?? '',

      /// NUMBERS (nullable)
      rate: json['rate'],
      totalScore: json['totalScore'],
      wallet: json['wallet'],
      numberOfReviews: json['numberOfReviews'],
      score: json['score'],
      varPoints: json['var_points'],
      // ممكن تكون null
      points: json['points'],
      freeHours: json['freeHours'],
      helpTotalHours: json['helpTotalHours'],
      warningCount: json['warningCount'],
      v: json['__v'],
      hourlyPrice: json['hourlyPrice'],

      /// OPTIONAL
      activationCode: json['activationCode'],
      activationCodeExpires: parseDate(json['activationCodeExpires']),
      fcmToken: json['fcmToken'] ?? '',

      activeTheme: json['activeTheme'] != null && json['activeTheme'] is Map
          ? ActiveTheme.fromJson(json['activeTheme'])
          : null,

      /// LISTS
      skills: (json['skills'] as List? ?? [])
          .map((e) => e is Map<String, dynamic>
              ? Skill.fromJson(e)
              : Skill(
                  skillName: e.toString(),
                  isVerified: false,
                  id: '',
                  quizScore: 0,
                  addedAt: '',
                ))
          .toList(),

      reviews: (json['reviews'] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),

      messages: json['messages'] ?? [],
      reports: json['reports'] ?? [],
      requests: json['requests'] ?? [],
      feedbackGiven: json['feedbackGiven'] ?? [],
      feedbackReceived: json['feedbackReceived'] ?? [],
      mentorSuggestions: json['mentorSuggestions'] ?? [],
      challenges: json['challenges'] ?? [],
      warnings: json['warnings'] ?? [],
      purchasedThemes: json['purchasedThemes'] ?? [],

      /// DATES
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: parseDate(json['updatedAt']) ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        userImage,
        profile,
        blockInfo,
        track,
        id,
        name,
        email,
        isActive,
        role,
        activeTheme,
        rate,
        totalScore,
        wallet,
        numberOfReviews,
        score,
        varPoints,
        points,
        freeHours,
        helpTotalHours,
        warningCount,
        v,
        hourlyPrice,
        activationCode,
        activationCodeExpires,
        fcmToken,
        skills,
        reviews,
        messages,
        reports,
        requests,
        feedbackGiven,
        feedbackReceived,
        mentorSuggestions,
        challenges,
        warnings,
        purchasedThemes,
        createdAt,
        updatedAt,
      ];
}
