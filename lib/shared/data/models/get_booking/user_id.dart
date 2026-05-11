import '../user/usesr_image.dart';

class UserBooking {
  final String id;
  final String name;
  final String email;
  final UserImage userImage;
  final String role;

  UserBooking({
    required this.id,
    required this.name,
    required this.email,
    required this.userImage,
    required this.role,
  });

  factory UserBooking.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserBooking.empty();

    return UserBooking(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '',
      userImage: json['userImage'] != null
          ? UserImage.fromJson(json['userImage'])
          : UserImage.empty(),
      role: json['role']?.toString() ?? 'Normal',
    );
  }

  factory UserBooking.empty() {
    return UserBooking(
      id: '',
      name: '',
      email: '',
      userImage: UserImage.empty(),
      role: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'userImage': userImage.toJson(),
    };
  }
}
