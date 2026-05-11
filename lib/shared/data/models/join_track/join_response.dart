import 'join_track_error_response.dart';
import 'join_track_success_response.dart';

sealed class JoinTrackResponse {}

class JoinTrackSuccess extends JoinTrackResponse {
  final JoinTrackSuccessResponse success;

  JoinTrackSuccess(this.success);
}

class JoinTrackFailure extends JoinTrackResponse {
  final JoinTrackErrorResponse error;

  JoinTrackFailure(this.error);
}
