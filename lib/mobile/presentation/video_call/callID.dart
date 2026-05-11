// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:skill_swap/mobile/presentation/video_call/rateSession.dart';
// import 'package:zego_uikit/zego_uikit.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
//
// import '../../../shared/bloc/submit_review_bloc/submit_review_bloc.dart';
// import '../../../shared/dependency_injection/injection.dart';
// import '../sessions/models/session.dart';
// import 'LiveKeys.dart';
//
// class CallPage extends StatefulWidget {
//   final SessionModel session;
//
//   const CallPage({Key? key, required this.session}) : super(key: key);
//
//   @override
//   State<CallPage> createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//   bool isFullscreen = true;
//
//   @override
//   void initState() {
//     super.initState();
//     ZegoUIKit().logout();
//     requestPermissions();
//   }
//
//   Future<void> requestPermissions() async {
//     await [
//       Permission.camera,
//       Permission.microphone,
//       Permission.bluetoothConnect,
//     ].request();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Stack(
//         children: [
//           ZegoUIKitPrebuiltCall(
//             appID: LiveKeys.appId,
//             appSign: LiveKeys.appSign,
//             userID: widget.session.userId,
//             userName: widget.session.userName,
//             callID: widget.session.bookingCode,
//             plugins: [ZegoUIKitSignalingPlugin()],
//             events: ZegoUIKitPrebuiltCallEvents(
//               onCallEnd: (event, defaultAction) {
//                 defaultAction();
//
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   if (!mounted) return;
//
//                   if (widget.session.isStudent) {
//                     Get.offAll(BlocProvider(
//                       create: (_) => sl<SubmitReviewBloc>(),
//                       child: RateSessionScreen(session: widget.session),
//                     ));
//                     // Navigator.pushReplacement(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (_) => BlocProvider(
//                     //       create: (_) => sl<SubmitReviewBloc>(),
//                     //       child: RateSessionScreen(session: widget.session),
//                     //     ),
//                     //   ),
//                     // );
//                   }
//                 });
//               },
//             ),
//             config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//               ..avatarBuilder = (context, size, user, extraInfo) {
//                 final firstLetter =
//                     user?.name.characters.first.toUpperCase() ?? '?';
//
//                 return Container(
//                   width: size.width,
//                   height: size.height,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white10,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     firstLetter,
//                     style: TextStyle(
//                       fontSize: size.width * 0.4,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               }
//               ..bottomMenuBarConfig.buttons = [
//                 ZegoCallMenuBarButtonName.toggleMicrophoneButton,
//                 ZegoCallMenuBarButtonName.toggleCameraButton,
//                 ZegoCallMenuBarButtonName.switchCameraButton,
//                 ZegoCallMenuBarButtonName.hangUpButton,
//                 ZegoCallMenuBarButtonName.toggleScreenSharingButton,
//               ]
//               ..audioVideoViewConfig.foregroundBuilder =
//                   (context, size, user, extraInfo) {
//                 return Positioned(
//                   top: 20,
//                   right: 20,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       isFullscreen = !isFullscreen;
//
//                       ZegoUIKitPrebuiltCallController()
//                           .screenSharing
//                           .showViewInFullscreenMode(
//                             user?.id ?? '',
//                             isFullscreen,
//                           );
//                     },
//                     child: const Text('Full Screen'),
//                   ),
//                 );
//               },
//           ),
//           StreamBuilder<List<ZegoUIKitUser>>(
//             stream: ZegoUIKit().getUserListStream(),
//             builder: (context, snapshot) {
//               final remoteUsers = ZegoUIKit().getRemoteUsers();
//
//               if (remoteUsers.isEmpty) {
//                 return _buildWaitingUI(
//                   widget.session.userName,
//                   widget.session.userImage,
//                 );
//               }
//
//               return const SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWaitingUI(String name, String? avatarUrl) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF0B1D2A),
//               Color(0xFF133B5C),
//               Color(0xFF1E5F74),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildPrettyAvatar(name, avatarUrl),
//               const SizedBox(height: 30),
//               const SizedBox(
//                 width: 28,
//                 height: 28,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Waiting for $name',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Connecting video call...',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPrettyAvatar(String name, String? avatarUrl) {
//     final firstLetter =
//         name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
//
//     return CircleAvatar(
//       radius: 46,
//       backgroundColor: Colors.white10,
//       backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
//           ? NetworkImage(avatarUrl)
//           : null,
//       child: (avatarUrl == null || avatarUrl.isEmpty)
//           ? Text(
//               firstLetter,
//               style: const TextStyle(
//                 fontSize: 32,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           : null,
//     );
//   }
// }
