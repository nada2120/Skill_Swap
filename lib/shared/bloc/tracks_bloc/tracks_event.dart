abstract class TracksEvent {}

class LoadTracksEvent extends TracksEvent {}

class JoinTrackEvent extends TracksEvent {
  final String trackId;

  JoinTrackEvent(this.trackId);
}

class LeaveChatEvent extends TracksEvent {
  final String chatId;

  LeaveChatEvent(this.chatId);
}
