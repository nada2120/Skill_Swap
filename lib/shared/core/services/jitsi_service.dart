import 'dart:developer';

import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

import 'call_services.dart';

class JitsiService {
  final String roomId;
  final String userName;
  final bool isStudent;

  JitsiService({
    required this.roomId,
    required this.userName,
    required this.isStudent,
  });

  final JitsiMeet jitsiMeet = JitsiMeet();
  final CallService callService = CallService();
  bool _closed = false; // 👈 هنا

  Future<void> joinMeeting({
    required Function() onClose,
  }) async {
    final options = JitsiMeetConferenceOptions(
      room: roomId,
      serverURL: "https://meet.ffmuc.net/",
      userInfo: JitsiMeetUserInfo(
        displayName: userName,
      ),
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
        "disableDeepLinking": true,
        "resolution": 720,
      },
      featureFlags: {
        "prejoinpage.enabled": false,
        "invite.enabled": false,
        "meeting-password.enabled": false,
        "chat.enabled": true,
        "raise-hand.enabled": true,
        "tile-view.enabled": true,
        "video-share.enabled": true,
        "pip.enabled": true,
      },
    );

    final listener = JitsiMeetEventListener(
      conferenceJoined: (url) async {
        log("joined call: $url");
        await callService.markUserJoined(
          roomId: roomId,
          isStudent: isStudent,
        );
      },
      participantJoined: (id, name, email, avatar) {
        log("participant joined: $name");
      },
      participantLeft: (id) {
        log("participant left: $id");
      },
      conferenceTerminated: (url, error) {
        log("call ended");
        if (_closed) return; // 👈
        _closed = true; // 👈
        onClose();
      },
      readyToClose: () {
        if (_closed) return; // 👈
        _closed = true; // 👈
        onClose();
      },
    );

    await jitsiMeet.join(options, listener);
  }

  Future<void> hangUp() async {
    await jitsiMeet.hangUp();
  }
}
