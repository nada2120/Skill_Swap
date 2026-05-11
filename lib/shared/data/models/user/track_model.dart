import 'package:equatable/equatable.dart';

class Track extends Equatable {
  final String id;
  final String name;
  final String slug;

  Track({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];

  factory Track.fromJson(Map<String, dynamic>? json) {
    return Track(
      id: json?['_id'] ?? '',
      name: json?['name'] ?? '',
      slug: json?['slug'] ?? '',
    );
  }

  factory Track.empty() {
    return Track(id: "", name: "", slug: "");
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
