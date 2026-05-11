import '../../../core/utils/id_normalizer.dart';

class ChatJoinModel {
  final String id;
  final String type;
  final List<dynamic> participants;
  final String name;
  final String trackId;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ChatJoinModel(
      {required this.id,
      required this.type,
      required this.participants,
      required this.name,
      required this.trackId,
      required this.image,
      required this.createdAt,
      required this.updatedAt,
      required this.v});

  factory ChatJoinModel.fromJson(Map<String, dynamic> json) {
    return ChatJoinModel(
      id: IdNormalizer.normalize(json['_id']),
      type: json['type'],
      participants: json['participants'],
      name: json['name'],
      trackId: json['trackId'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'participants': participants,
      'name': name,
      'trackId': trackId,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v
    };
  }
}
