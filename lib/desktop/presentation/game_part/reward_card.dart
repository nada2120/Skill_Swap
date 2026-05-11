// import 'reward_item.dart';
//
// class RewardCard extends StatelessWidget {
//   final int? rank;
//   final String? range;
//   final bool preview;
//   final bool isClaim;
//   final bool isClaimed;
//   final bool isLoading;
//   final VoidCallback? onCollect;
//
//   const RewardCard({
//     super.key,
//     this.rank,
//     this.range,
//     this.preview = false,
//     this.isClaim = false,
//     this.isClaimed = false,
//     this.isLoading = false,
//     this.onCollect,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final rewards = _getRewards();
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: _getGradient(),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           /// 🏆 Title
//           Text(
//             rank != null ? "Rank #$rank" : "Rank $range",
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           /// 🎁 Rewards (صور)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: rewards,
//           ),
//
//           const SizedBox(height: 12),
//
//           /// 🔘 Preview
//           if (preview)
//             const Text(
//               "Finish in this rank to win 🎯",
//               style: TextStyle(fontSize: 12),
//             ),
//
//           /// 🔘 Claim Button
//           if (isClaim && !isClaimed)
//             ElevatedButton(
//               onPressed: isLoading ? null : onCollect,
//               child: isLoading
//                   ? const SizedBox(
//                 height: 18,
//                 width: 18,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//                   : const Text("Collect"),
//             ),
//
//           /// ✅ Collected
//           if (isClaimed)
//             const Text(
//               "Collected ✅",
//               style: TextStyle(color: Colors.green),
//             ),
//         ],
//       ),
//     );
//   }
//
//   /// 🎨 Gradient حسب الرانك
//   Gradient _getGradient() {
//     if (rank == 1) {
//       return const LinearGradient(
//         colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
//       );
//     } else if (rank == 2) {
//       return const LinearGradient(
//         colors: [Color(0xFFE0E0E0), Color(0xFF90A4AE)],
//       );
//     } else if (rank == 3) {
//       return const LinearGradient(
//         colors: [Color(0xFFFFB74D), Color(0xFFE65100)],
//       );
//     }
//
//     return const LinearGradient(
//       colors: [Colors.white, Colors.white],
//     );
//   }
//
//   /// 🎁 Rewards UI
//   List<Widget> _getRewards() {
//     if (rank == 1) {
//       return const [
//         RewardItem(image: "assets/coupon.png", label: "50%"),
//         RewardItem(image: "assets/time.png", label: "3h"),
//         RewardItem(image: "assets/coins.png", label: "500"),
//         RewardItem(image: "assets/frame.png", label: "VIP"),
//       ];
//     }
//
//     if (rank == 2) {
//       return const [
//         RewardItem(image: "assets/coupon.png", label: "30%"),
//         RewardItem(image: "assets/coins.png", label: "300"),
//       ];
//     }
//
//     if (rank == 3) {
//       return const [
//         RewardItem(image: "assets/coins.png", label: "150"),
//       ];
//     }
//
//     return const [
//       RewardItem(image: "assets/coins.png", label: "50"),
//     ];
//   }
// }
