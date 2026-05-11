// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_success_response_new.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginSuccessResponseNew _$LoginSuccessResponseNewFromJson(
        Map<String, dynamic> json) =>
    LoginSuccessResponseNew(
      message: json['message'] as String,
      flag: json['flag'] as bool,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      id: json['id'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$LoginSuccessResponseNewToJson(
        LoginSuccessResponseNew instance) =>
    <String, dynamic>{
      'message': instance.message,
      'flag': instance.flag,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'id': instance.id,
      'role': instance.role,
    };
