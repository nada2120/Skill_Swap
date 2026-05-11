// import 'package:flutter/material.dart';
//
// import '../../../mobile/presentation/sessions/models/session.dart';
// import 'call_screen.dart';
//
// class IncomingCallScreen extends StatelessWidget {
//   final SessionModel session;
//
//   const IncomingCallScreen({
//     super.key,
//     required this.session,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(
//               radius: 40,
//               backgroundImage: session.userImage.isNotEmpty
//                   ? NetworkImage(session.userImage)
//                   : null,
//               child: session.userImage.isEmpty
//                   ? Text(
//                       session.userName[0],
//                       style: const TextStyle(color: Colors.white),
//                     )
//                   : null,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Incoming call from ${session.userName}",
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CallScreen(
//                       session: session,
//                     ),
//                   ),
//                 );
//               },
//               child: const Text("Accept"),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Decline"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
