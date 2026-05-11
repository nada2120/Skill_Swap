import 'chat_join_model.dart';

class JoinTrackSuccessResponse {
  final String message;
  final ChatJoinModel chatDetails;

  JoinTrackSuccessResponse({
    required this.message,
    required this.chatDetails,
  });

  factory JoinTrackSuccessResponse.fromJson(Map<String, dynamic> json) {
    return JoinTrackSuccessResponse(
      message: json['message'] ?? '',
      chatDetails: ChatJoinModel.fromJson(json['chat'] as Map<String, dynamic>),
    );
  }
}
