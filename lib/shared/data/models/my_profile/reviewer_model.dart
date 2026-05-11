import '../user/usesr_image.dart';

class Reviewer {
  final String id;
  final String name;
  final UserImage userImage;
  final String role;

  Reviewer({
    required this.id,
    required this.name,
    required this.userImage,
    required this.role,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'User',
      role: json['role'] ?? 'Normal',
      userImage: json['userImage'] != null
          ? UserImage.fromJson(json['userImage'])
          : UserImage.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role': role,
      'userImage': userImage.toJson(),
    };
  }

  factory Reviewer.empty() {
    return Reviewer(
      id: '',
      name: '',
      role: '',
      userImage: UserImage.empty(),
    );
  }
}
