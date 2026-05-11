import 'package:skill_swap/shared/data/models/user/Block_info.dart';
import 'package:skill_swap/shared/data/models/user/profile_model.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';
import 'package:skill_swap/shared/data/models/user/track_model.dart';
import 'package:skill_swap/shared/data/models/user/usesr_image.dart';
import 'package:skill_swap/shared/data/models/user/warnning_model.dart';

import '../my_profile/review_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final bool confirmEmail;
  final num warningCount;
  final num hourlyPrice;
  final UserImage userImage;
  final Profile profile;
  final BlockInfo blockInfo;
  final Track track;
  final List<Skill> skills;
  final List<WarningModel> warnings;
  final String? activeTheme;

  final num rate;
  final num freeHours;
  final num helpTotalHours;
  final num wallet;
  final num totalScore;
  final num numberOfReviews;

  final String? activationCode;
  final DateTime? activationCodeExpires;
  final String? fcmToken;

  final num score;
  final num varPoints;

  final List<dynamic> challenges;
  final List<dynamic> messages;
  final List<dynamic> reports;
  final List<dynamic> requests;
  final List<dynamic> feedbackGiven;
  final List<dynamic> feedbackReceived;
  final List<dynamic> mentorSuggestions;
  final List<dynamic> purchasedThemes;
  final List<ReviewModel> reviews;

  final int v;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.confirmEmail,
    required this.warningCount,
    required this.userImage,
    required this.profile,
    required this.blockInfo,
    required this.track,
    required this.skills,
    required this.warnings,
    required this.rate,
    required this.freeHours,
    required this.helpTotalHours,
    required this.wallet,
    required this.hourlyPrice,
    required this.totalScore,
    required this.numberOfReviews,
    this.activationCode,
    this.activationCodeExpires,
    this.fcmToken,
    required this.score,
    required this.activeTheme,
    required this.purchasedThemes,
    required this.varPoints,
    required this.challenges,
    required this.messages,
    required this.reports,
    required this.requests,
    required this.feedbackGiven,
    required this.feedbackReceived,
    required this.mentorSuggestions,
    required this.reviews,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    DateTime? parseDate(String? value) {
      if (value == null || value.isEmpty) return null;
      return DateTime.tryParse(value);
    }

    return UserModel(
      id: json?['_id'] ?? '',
      name: json?['name'] ?? '',
      email: json?['email'] ?? '',
      role: json?['role'] ?? '',
      isActive: json?['isActive'] ?? false,
      confirmEmail: json?['confirmEmail'] ?? false,

      warningCount: parseInt(json?['warningCount']),
      hourlyPrice: parseInt(json?['hourlyPrice']),

      /// 🔥 SAFE OBJECTS
      userImage: json?['userImage'] != null
          ? UserImage.fromJson(json?['userImage'])
          : UserImage.empty(),

      profile: json?['profile'] != null
          ? Profile.fromJson(json?['profile'])
          : Profile.empty(),

      blockInfo: json?['blockInfo'] != null
          ? BlockInfo.fromJson(json?['blockInfo'])
          : BlockInfo.empty(),

      track: json?['track'] != null
          ? Track.fromJson(json?['track'])
          : Track.empty(),

      /// 🔥 SAFE LISTS
      skills: json?['skills'] != null
          ? (json?['skills'] as List)
              .map((e) => e is Map<String, dynamic>
                  ? Skill.fromJson(e)
                  : Skill(
                      skillName: e.toString(),
                      isVerified: false,
                      id: '',
                      quizScore: 0,
                      addedAt: '',
                    ))
              .toList()
          : [],

      warnings: (json?['warnings'] as List? ?? [])
          .map((e) => WarningModel.fromJson(e))
          .toList(),

      reviews: (json?['reviews'] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),

      /// 🔥 NUMBERS (FIXED)
      rate: parseDouble(json?['rate']),
      freeHours: parseDouble(json?['freeHours']),
      helpTotalHours: parseDouble(json?['helpTotalHours']),
      wallet: parseDouble(json?['wallet']),

      totalScore: parseInt(json?['totalScore']),
      numberOfReviews: parseInt(json?['numberOfReviews']),
      score: parseInt(json?['score']),
      varPoints: parseInt(json?['var_points']),
      v: parseInt(json?['__v']),

      /// ❗ كان ناقص عندك
      // points (لو موجود في API)
      // ضيفه لو محتاجه

      /// 🔥 OPTIONAL
      activeTheme: json?['activeTheme'],
      activationCode: json?['activationCode'],
      activationCodeExpires: parseDate(json?['activationCodeExpires']),
      fcmToken: json?['fcmToken'],

      /// 🔥 ARRAYS
      challenges: json?['challenges'] ?? [],
      messages: json?['messages'] ?? [],
      reports: json?['reports'] ?? [],
      requests: json?['requests'] ?? [],
      feedbackGiven: json?['feedbackGiven'] ?? [],
      feedbackReceived: json?['feedbackReceived'] ?? [],
      mentorSuggestions: json?['mentorSuggestions'] ?? [],
      purchasedThemes: json?['purchasedThemes'] ?? [],

      /// 🔥 DATES
      createdAt: parseDate(json?['createdAt']) ?? DateTime.now(),
      updatedAt: parseDate(json?['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "role": role,
      "isActive": isActive,
      "confirmEmail": confirmEmail,
      "warningCount": warningCount,
      "userImage": userImage.toJson(),
      "profile": profile.toJson(),
      "blockInfo": blockInfo.toJson(),
      "track": track.toJson(),
      "skills": skills.map((e) => e.toJson()).toList(),
      "warnings": warnings.map((e) => e.toJson()).toList(),
      "rate": rate,
      "freeHours": freeHours,
      "hourlyPrice": hourlyPrice,
      "helpTotalHours": helpTotalHours,
      "wallet": wallet,
      "totalScore": totalScore,
      "numberOfReviews": numberOfReviews,
      "activationCode": activationCode,
      "activationCodeExpires": activationCodeExpires?.toIso8601String(),
      "fcmToken": fcmToken,
      "score": score,
      "var_points": varPoints,
      "activeTheme": activeTheme,
      "challenges": challenges,
      "messages": messages,
      "purchasedThemes": purchasedThemes,
      "reports": reports,
      "requests": requests,
      "feedbackGiven": feedbackGiven,
      "feedbackReceived": feedbackReceived,
      "mentorSuggestions": mentorSuggestions,
      "reviews": reviews.map((e) => e.toJson()).toList(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "__v": v,
    };
  }

  UserModel copyWith({
    String? name,
    double? rate,
    int? wallet,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      isActive: isActive,
      confirmEmail: confirmEmail,
      warningCount: warningCount,
      userImage: userImage,
      profile: profile,
      hourlyPrice: hourlyPrice,
      blockInfo: blockInfo,
      track: track,
      skills: skills,
      warnings: warnings,
      rate: rate ?? this.rate,
      freeHours: freeHours,
      helpTotalHours: helpTotalHours,
      wallet: wallet ?? this.wallet,
      totalScore: totalScore,
      numberOfReviews: numberOfReviews,
      activationCode: activationCode,
      activationCodeExpires: activationCodeExpires,
      fcmToken: fcmToken,
      score: score,
      varPoints: varPoints,
      challenges: challenges,
      messages: messages,
      purchasedThemes: purchasedThemes,
      reports: reports,
      requests: requests,
      feedbackGiven: feedbackGiven,
      feedbackReceived: feedbackReceived,
      mentorSuggestions: mentorSuggestions,
      reviews: reviews,
      activeTheme: activeTheme,
      v: v,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
