import '../user/usesr_image.dart';

class ParticipantModel {
  final String id;
  final String email;
  final String name;
  final UserImage userImage;

  ParticipantModel({
    required this.id,
    required this.email,
    required this.name,
    required this.userImage,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      userImage: UserImage.fromJson(json['userImage']),
    );
  }
}
