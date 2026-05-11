import 'package:json_annotation/json_annotation.dart';

part 'complete_profile_request.g.dart';

@JsonSerializable()
class SkillItem {
  final String skillName;
  final String? experienceLevel;

  SkillItem({required this.skillName, this.experienceLevel});

  factory SkillItem.fromJson(Map<String, dynamic> json) =>
      _$SkillItemFromJson(json);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'skillName': skillName,
    };
    if (experienceLevel != null) {
      map['experienceLevel'] = experienceLevel;
    }
    return map;
  }
}

@JsonSerializable()
class CompleteProfileRequest {
  final String userId;
  final String track;
  final List<SkillItem> skills;

  CompleteProfileRequest({
    required this.userId,
    required this.track,
    required this.skills,
  });

  factory CompleteProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteProfileRequestToJson(this);
}
