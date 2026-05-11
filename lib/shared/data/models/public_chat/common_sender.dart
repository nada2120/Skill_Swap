class Sender {
  final String id;
  final String name;
  final String role;
  final UserImage userImage;

  Sender({
    required this.id,
    required this.userImage,
    required this.name,
    required this.role,
  });

  factory Sender.fromJson(Map<String, dynamic>? json) => Sender(
        id: json?['_id']?.toString() ?? 'unknown',
        name: json?['name']?.toString() ?? '',
        role: json?['role']?.toString() ?? '',
        userImage: UserImage.fromJson(json?['userImage']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'role': role,
        'userImage': userImage.toJson(),
      };
}

class UserImage {
  final String secureUrl;
  final String publicId;

  UserImage({required this.secureUrl, required this.publicId});

  factory UserImage.fromJson(Map<String, dynamic>? json) => UserImage(
        secureUrl: json?['secure_url']?.toString() ?? '',
        publicId: json?['public_id']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'secure_url': secureUrl,
        'public_id': publicId,
      };
}
