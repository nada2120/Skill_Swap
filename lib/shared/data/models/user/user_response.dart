import 'package:skill_swap/shared/data/models/user/user_data.dart';

class UsersResponse {
  final String message;
  final UsersData data;

  UsersResponse({
    required this.message,
    required this.data,
  });

  factory UsersResponse.fromJson(Map<String, dynamic>? json) {
    return UsersResponse(
      message: json?['message'] ?? '',
      data: UsersData.fromJson(json?['data']),
    );
  }
}
