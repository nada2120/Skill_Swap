import 'package:skill_swap/shared/data/models/public_chat/participant_model.dart';

import 'last_message_model.dart';

class GetChatModel {
  final String id;
  final String type;
  final String name;
  final String image;
  final List<ParticipantModel> participants;
  final TrackModel? track;
  final LastMessageModel? lastMessage;
  final String createdAt;
  final String updatedAt;

  bool isJoined(String currentUserId) {
    return participants.any((p) => p.id.trim() == currentUserId.trim());
  }

  GetChatModel({
    required this.id,
    required this.type,
    required this.name,
    required this.image,
    required this.participants,
    this.track,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetChatModel.fromJson(Map<String, dynamic> json) {
    return GetChatModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      participants: (json['participants'] as List)
          .map((e) => ParticipantModel.fromJson(e))
          .toList(),
      track:
      json['trackId'] != null ? TrackModel.fromJson(json['trackId']) : null,
      lastMessage: json['lastMessage'] != null
          ? LastMessageModel.fromJson(json['lastMessage'])
          : null,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  GetChatModel copyWith({
    String? id,
    String? type,
    String? name,
    String? image,
    List<ParticipantModel>? participants,
    TrackModel? track,
    LastMessageModel? lastMessage,
    String? createdAt,
    String? updatedAt,
  }) {
    return GetChatModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      image: image ?? this.image,
      participants: participants ?? this.participants,
      track: track ?? this.track,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class TrackModel {
  final String id;
  final String name;

  TrackModel({
    required this.id,
    required this.name,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}