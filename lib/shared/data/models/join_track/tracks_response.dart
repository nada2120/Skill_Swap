import '../join_track/track_model.dart';

class TracksResponse {
  String? message;
  List<ListTracksModel>? tracks;

  TracksResponse({
    this.message,
    this.tracks,
  });

  TracksResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['tracks'] != null) {
      tracks = [];
      json['tracks'].forEach((v) {
        tracks!.add(ListTracksModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'tracks': tracks?.map((e) => e.toJson()).toList(),
    };
  }
}
