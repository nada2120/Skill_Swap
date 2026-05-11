// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterSuccessResponse _$RegisterSuccessResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterSuccessResponse(
      message: json['message'] as String,
      flag: json['flag'] as bool,
      id: json['userId'] as String,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$RegisterSuccessResponseToJson(
        RegisterSuccessResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'flag': instance.flag,
      'userId': instance.id,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
