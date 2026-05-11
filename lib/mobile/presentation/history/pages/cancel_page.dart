// import 'package:flutter/material.dart';
//
// import '../../../../shared/constants/strings.dart';
// import '../widgets/history_card.dart';
//
// class CancelSessionsPage extends StatelessWidget {
//   const CancelSessionsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // MediaQuery for responsive sizing
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: screenWidth * 0.03, // 3% padding from sides
//         vertical: screenHeight * 0.01, // 1% padding from top/bottom
//       ),
//       child: ListView.separated(
//         shrinkWrap: true,
//         padding: EdgeInsets.zero,
//         itemCount: AppData.cancelledSessions.length,
//         separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.01),
//         itemBuilder: (_, index) {
//           return HistoryCard(data: AppData.cancelledSessions[index]);
//         },
//       ),
//     );
//   }
// }
