class UpdateProfile {
  final String? bio;

  UpdateProfile({this.bio});

  factory UpdateProfile.fromJson(Map<String, dynamic>? json) {
    return UpdateProfile(
      bio: json?['bio']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (bio != null && bio!.trim().isNotEmpty) {
      data['bio'] = bio;
    }

    return data;
  }
}
