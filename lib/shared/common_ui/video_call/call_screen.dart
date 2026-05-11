import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/common_ui/video_call/rateSession.dart';

import '../../../mobile/presentation/sessions/models/session.dart';
import '../../bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../core/services/call_services.dart';
import '../../core/services/jitsi_service.dart';
import '../../dependency_injection/injection.dart';
import '../screen_manager/screen_manager.dart';

class CallScreen extends StatefulWidget {
  final int durationMinutes;
  final SessionModel session;

  const CallScreen({
    super.key,
    required this.durationMinutes,
    required this.session,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallService callService = CallService();
  Timer? countdownTimer;

  late Duration remainingDuration;
  StreamSubscription? sub;

  late final DateTime endTime;

  late final JitsiService jitsiService;

  @override
  void initState() {
    super.initState();

    jitsiService = JitsiService(
      roomId: widget.session.bookingCode,
      userName: widget.session.userName,
      isStudent: widget.session.isStudent,
    );

    endTime = DateTime.now().add(Duration(minutes: widget.durationMinutes));
    remainingDuration = Duration(minutes: widget.durationMinutes);

    startCountdown();
    listenToCall();
    startCall();
    startWatcher();
  }

  void startWatcher() {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      final now = DateTime.now();

      final data = await callService.firestore
          .collection("calls")
          .doc(widget.session.bookingCode)
          .get();

      final call = data.data() as Map<String, dynamic>?;

      if (call == null) return;

      // ⏱️ 1. انتهاء الوقت
      if (now.isAfter(endTime)) {
        timer.cancel();
        await jitsiService.hangUp();
        await callService.endCall(widget.session.bookingCode);
        handleEnd();
        return;
      }

      final createdAt = (call['createdAt'] as Timestamp).toDate();
      final waiting = now.difference(createdAt).inMinutes;

      final studentJoined = call['studentJoined'] ?? false;
      final instructorJoined = call['instructorJoined'] ?? false;

      if ((!studentJoined || !instructorJoined) && waiting >= 15) {
        timer.cancel();
        await jitsiService.hangUp();
        await callService.endCall(widget.session.bookingCode);
        handleNoUser();
        return;
      }
    });
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final now = DateTime.now();

        setState(() {
          remainingDuration = endTime.difference(now);

          if (remainingDuration.isNegative) {
            remainingDuration = Duration.zero;
          }
        });
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  void handleEnd() {
    final session = widget.session;

    if (session.isStudent) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<SubmitReviewBloc>(),
            child: RateSessionScreen(
                sessionId: widget.session.sessionId,
                userName: widget.session.userName,
                dateTime: widget.session.dateTime),
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScreenManager(initialIndex: 3),
        ),
      );
    }
  }

  void handleNoUser() {
    final session = widget.session;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScreenManager(
          initialIndex: 3,
          showNoUserDialog: true,
          noUserBookingCode: session.bookingCode,
          noUserPrice: session.price,
          isStudent: session.isStudent,
        ),
      ),
    );
  }

  void startCall() async {
    await jitsiService.joinMeeting(
      onClose: () async {
        await callService.endCall(widget.session.bookingCode);

        if (!mounted) return;

        handleEnd();
      },
    );
  }

  void listenToCall() {
    sub =
        callService.listenCall(widget.session.bookingCode).listen((doc) async {
      final data = doc.data() as Map<String, dynamic>?;

      if (data == null) return;

      if (data["status"] == "ended") {
        await jitsiService.hangUp();
        //   if (mounted) Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    );
  }
}
