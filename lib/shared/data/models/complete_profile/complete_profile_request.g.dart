// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillItem _$SkillItemFromJson(Map<String, dynamic> json) => SkillItem(
      skillName: json['skillName'] as String,
      experienceLevel: json['experienceLevel'] as String?,
    );

Map<String, dynamic> _$SkillItemToJson(SkillItem instance) => <String, dynamic>{
      'skillName': instance.skillName,
      'experienceLevel': instance.experienceLevel,
    };

CompleteProfileRequest _$CompleteProfileRequestFromJson(
        Map<String, dynamic> json) =>
    CompleteProfileRequest(
      userId: json['userId'] as String,
      track: json['track'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => SkillItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompleteProfileRequestToJson(
        CompleteProfileRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'track': instance.track,
      'skills': instance.skills,
    };
