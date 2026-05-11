import 'package:equatable/equatable.dart';

class UserImage extends Equatable {
  final String secureUrl;
  final String? publicId;

  UserImage({
    required this.secureUrl,
    this.publicId,
  });

  @override
  List<Object?> get props => [
        secureUrl,
        publicId,
      ];

  factory UserImage.fromJson(Map<String, dynamic>? json) {
    return UserImage(
      secureUrl: json?['secure_url'] ?? '',
      publicId: json?['public_id'],
    );
  }

  factory UserImage.empty() {
    return UserImage(secureUrl: "", publicId: "");
  }

  Map<String, dynamic> toJson() {
    return {
      'secureUrl': secureUrl,
      'publicId': publicId,
    };
  }
}
