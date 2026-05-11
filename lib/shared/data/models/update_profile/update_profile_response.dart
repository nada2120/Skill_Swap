import 'package:skill_swap/shared/data/models/update_profile/update_user.dart';

sealed class UpdateProfileResponse {
  final String message;

  const UpdateProfileResponse(this.message);
}

class UpdateProfileData extends UpdateProfileResponse {
  final UpdateUser user;

  const UpdateProfileData({
    required String message,
    required this.user,
  }) : super(message);

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) {
    return UpdateProfileData(
      message: json['message'] ?? '',
      user: UpdateUser.fromJson(json['user'] ?? {}),
    );
  }
}

class UpdateProfileFailure extends UpdateProfileResponse {
  const UpdateProfileFailure({required String error}) : super(error);
}
