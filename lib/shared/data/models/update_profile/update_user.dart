class UpdateUser {
  final String id;
  final String name;
  final String email;
  final bool isActive;
  final bool confirmEmail;
  final String? activationCode;
  final String? activationCodeExpires;
  final String password;
  final num rate;
  final String role;
  final num freeHours;
  final num helpTotalHours;
  final num totalScore;
  final UserImage userImage;
  final Profile profile;
  final BlockInfo blockInfo;
  final List<SkillModel> skills;
  final List<dynamic> challenges;
  final List<dynamic> messages;
  final List<dynamic> reports;
  final List<dynamic> requests;
  final List<dynamic> feedbackGiven;
  final List<dynamic> feedbackReceived;
  final List<dynamic> mentorSuggestions;
  final String? forgetCode;
  final num warningCount;
  final List<dynamic> warnings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final num v;
  final String track;

  UpdateUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    required this.confirmEmail,
    this.activationCode,
    this.activationCodeExpires,
    required this.password,
    required this.rate,
    required this.role,
    required this.freeHours,
    required this.helpTotalHours,
    required this.totalScore,
    required this.userImage,
    required this.profile,
    required this.blockInfo,
    required this.skills,
    required this.challenges,
    required this.messages,
    required this.reports,
    required this.requests,
    required this.feedbackGiven,
    required this.feedbackReceived,
    required this.mentorSuggestions,
    this.forgetCode,
    required this.warningCount,
    required this.warnings,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.track,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        isActive: json['isActive'] ?? false,
        confirmEmail: json['confirmEmail'] ?? false,
        activationCode: json['activationCode']?.toString(),
        activationCodeExpires: json['activationCodeExpires']?.toString(),
        password: json['password']?.toString() ?? '',
        rate: json['rate'] ?? 0,
        role: json['role']?.toString() ?? '',
        freeHours: json['freeHours'] ?? 0,
        helpTotalHours: json['helpTotalHours'] ?? 0,
        totalScore: json['totalScore'] ?? 0,
        userImage: UserImage.fromJson(json['userImage'] ?? {}),
        profile: Profile.fromJson(json['profile'] ?? {}),
        blockInfo: BlockInfo.fromJson(json['blockInfo'] ?? {}),
        skills: (json['skills'] as List? ?? [])
            .map((x) => SkillModel.fromJson(x))
            .toList(),
        challenges: json['challenges'] ?? [],
        messages: json['messages'] ?? [],
        reports: json['reports'] ?? [],
        requests: json['requests'] ?? [],
        feedbackGiven: json['feedbackGiven'] ?? [],
        feedbackReceived: json['feedbackReceived'] ?? [],
        mentorSuggestions: json['mentorSuggestions'] ?? [],
        forgetCode: json['forgetCode']?.toString(),
        warningCount: json['warningCount'] ?? 0,
        warnings: json['warnings'] ?? [],
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
        v: json['__v'] ?? 0,
        track: json['track']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'isActive': isActive,
        'confirmEmail': confirmEmail,
        'activationCode': activationCode,
        'activationCodeExpires': activationCodeExpires,
        'password': password,
        'rate': rate,
        'role': role,
        'freeHours': freeHours,
        'helpTotalHours': helpTotalHours,
        'totalScore': totalScore,
        'userImage': userImage.toJson(),
        'profile': profile.toJson(),
        'blockInfo': blockInfo.toJson(),
        'skills': skills.map((x) => x.toJson()).toList(),
        'challenges': challenges,
        'messages': messages,
        'reports': reports,
        'requests': requests,
        'feedbackGiven': feedbackGiven,
        'feedbackReceived': feedbackReceived,
        'mentorSuggestions': mentorSuggestions,
        'forgetCode': forgetCode,
        'warningCount': warningCount,
        'warnings': warnings,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
        'track': track,
      };
}

class UserImage {
  final String secureUrl;
  final String publicId;

  UserImage({
    required this.secureUrl,
    required this.publicId,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        secureUrl: json['secure_url']?.toString() ?? '',
        publicId: json['public_id']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'secure_url': secureUrl,
        'public_id': publicId,
      };
}

class Profile {
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

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        bio: json['bio']?.toString() ?? '',
        skillSummary: json['skillSummary']?.toString() ?? '',
        reputationScore: json['reputationScore'] ?? 0,
        lastUpdated: json['lastUpdated']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'bio': bio,
        'skillSummary': skillSummary,
        'reputationScore': reputationScore,
        'lastUpdated': lastUpdated,
      };
}

class BlockInfo {
  final bool isBlocked;
  final String? blockedUntil;
  final String blockReason;

  BlockInfo({
    required this.isBlocked,
    this.blockedUntil,
    required this.blockReason,
  });

  factory BlockInfo.fromJson(Map<String, dynamic> json) => BlockInfo(
        isBlocked: json['isBlocked'] ?? false,
        blockedUntil: json['blockedUntil']?.toString(),
        blockReason: json['blockReason']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'isBlocked': isBlocked,
        'blockedUntil': blockedUntil,
        'blockReason': blockReason,
      };
}

class SkillModel {
  final String skillName;
  final bool isVerified;
  final int quizScore;
  final String id;
  final DateTime addedAt;

  SkillModel({
    required this.skillName,
    required this.isVerified,
    required this.quizScore,
    required this.id,
    required this.addedAt,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        skillName: json['skillName']?.toString() ?? '',
        isVerified: json['isVerified'] ?? false,
        quizScore: json['quizScore'] ?? 0,
        id: json['_id']?.toString() ?? '',
        addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'skillName': skillName,
        'isVerified': isVerified,
        'quizScore': quizScore,
        '_id': id,
        'addedAt': addedAt.toIso8601String(),
      };
}
