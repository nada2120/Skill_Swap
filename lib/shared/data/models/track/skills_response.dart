class SkillsResponse {
  final String message;
  final List<Skill> data;

  SkillsResponse({
    required this.message,
    required this.data,
  });

  factory SkillsResponse.fromJson(Map<String, dynamic> json) {
    return SkillsResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((e) => Skill.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Skill {
  final String id;
  final String name;
  final Track track;

  Skill({
    required this.id,
    required this.name,
    required this.track,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      track: Track.fromJson(json['track']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'track': track.toJson(),
    };
  }
}

class Track {
  final String id;
  final String name;

  Track({
    required this.id,
    required this.name,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
