import 'package:skill_swap/shared/data/models/user/user_model.dart';

class UsersData {
  final List<UserModel> users;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  UsersData(
      {required this.users,
      required this.total,
      required this.page,
      required this.limit,
      required this.totalPages});

  factory UsersData.fromJson(Map<String, dynamic>? json) {
    return UsersData(
      users: (json?['users'] as List? ?? [])
          .map((e) => UserModel.fromJson(e))
          .toList(),
      total: json?['total'] ?? 0,
      page: json?['page'] ?? 0,
      limit: json?['limit'] ?? 0,
      totalPages: json?['totalPages'] ?? 0,
    );
  }
}
