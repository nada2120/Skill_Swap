import 'package:skill_swap/shared/data/models/update_profile/update_profile.dart';
import 'package:skill_swap/shared/data/models/update_profile/update_skill.dart';

class UpdateProfileRequest {
  final String? name;
  final UpdateProfile? profile;
  final List<UpdateSkill>? skills;

  UpdateProfileRequest({
    this.name,
    this.profile,
    this.skills,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      name: json['name']?.toString(),
      profile: json['profile'] != null
          ? UpdateProfile.fromJson(json['profile'])
          : null,
      skills: json['skills'] != null
          ? (json['skills'] as List)
          .map((e) => UpdateSkill.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (name != null && name!.isNotEmpty) {
      data['name'] = name;
    }

    if (profile != null) {
      final profileJson = profile!.toJson();
      if (profileJson.isNotEmpty) {
        data['profile'] = profileJson;
      }
    }

    if (skills != null && skills!.isNotEmpty) {
      data['skills'] = skills!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}