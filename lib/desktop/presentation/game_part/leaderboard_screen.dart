import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../main.dart';
import '../../../mobile/presentation/game_part/rewards_screen.dart';
import '../../../mobile/presentation/game_stor/widgets/show_store_daiolg.dart';
import '../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../shared/data/models/user/user_model.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../../../shared/helper/local_storage.dart';

class LeaderboardScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const LeaderboardScreen({super.key, this.onBack});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<UserModel> users = [];
  bool isLoading = true;
  String? myId;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    try {
      final cubit = context.read<UsersCubit>();

      final usersData = await cubit.getLeaderboardUsers(page: 1);
      final userId = LocalStorage.getUserId();

      final myRank = usersData.indexWhere((u) => u.id == userId) + 1;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<StoreCubit>().handleRewards(myRank);
      });

      setState(() {
        users = usersData;
        myId = userId;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StoreCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: [
                /// 🔝 Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      /// 🔙 Back
                      IconButton(
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back),
                      ),

                      const SizedBox(width: 12),

                      /// 🏆 Title
                      const Text(
                        "Leaderboard",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      /// Rewards
                      IconButton(
                        icon: const Icon(Icons.card_giftcard),
                        onPressed: () {
                          final myRank = users.isEmpty
                              ? 0
                              : users.indexWhere(
                                    (u) => u.id == myId,
                                  ) +
                                  1;

                          desktopKey.currentState?.openSidePage(
                            body: BlocProvider.value(
                              value: context.read<StoreCubit>(),
                              child: RewardsScreen(
                                myRank: myRank,
                              ),
                            ),
                          );
                        },
                      ),

                      /// Help
                      IconButton(
                        onPressed: () {
                          showStoreDialog(
                            context,
                            isFirstTime: false,
                            title: "Leaderboard",
                            subtitle: "leaderboard",
                            rules:
                                "• Only the Top 10 players are displayed on the leaderboard\n"
                                "• Your score is based on your performance in the Challenge Rooms.\n",
                          );
                        },
                        icon: const Icon(Icons.help_outline_rounded),
                      ),
                    ],
                  ),
                ),

                /// ➖ Divider
                Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  color: Colors.grey.shade300,
                ),

                const SizedBox(height: 20),

                /// 📋 Leaderboard List
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 700,
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount:
                                    users.length > 10 ? 10 : users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  final rank = index + 1;
                                  final isMe = myId != null && user.id == myId;

                                  return _buildItem(
                                    user,
                                    rank,
                                    isMe,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Color getRankColor(int rank) {
  if (rank == 1) {
    return Colors.amber.shade700;
  } else if (rank == 2) {
    return Colors.grey.shade500;
  } else if (rank == 3) {
    return Colors.deepOrange.shade700;
  } else {
    return AppPalette.primary;
  }
}

Widget _buildItem(UserModel user, int rank, bool isMe) {
  final displayName = isMe ? "You" : user.name;
  final rankColor = getRankColor(rank);

  Gradient backgroundGradient;

  if (rank == 1) {
    backgroundGradient = const LinearGradient(
      colors: [
        Color(0xFFFFD54F),
        Color(0xFFFFC107),
        Color(0xFFFFA000),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (rank == 2) {
    backgroundGradient = const LinearGradient(
      colors: [
        Color(0xFFE0E0E0),
        Color(0xFFB0BEC5),
        Color(0xFF90A4AE),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (rank == 3) {
    backgroundGradient = const LinearGradient(
      colors: [
        Color(0xFFFFB74D),
        Color(0xFFF57C00),
        Color(0xFFE65100),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else {
    backgroundGradient = const LinearGradient(
      colors: [Colors.white, Colors.white],
    );
  }

  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      gradient: backgroundGradient,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 14,
          offset: const Offset(0, 8),
        ),
      ],
      border: isMe ? Border.all(color: AppPalette.primary, width: 2) : null,
    ),
    child: Stack(
      children: [
        Row(
          children: [
            _buildRankBadge(rank),

            const SizedBox(width: 14),

            /// 👤 Avatar
            Container(
              decoration: rank <= 3
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: rankColor.withOpacity(0.6),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : null,
              child: CircleAvatar(
                radius: rank <= 3 ? 30 : 22,
                backgroundColor: AppPalette.primary.withOpacity(0.15),
                backgroundImage: (user.userImage.secureUrl != null &&
                        user.userImage.secureUrl!.isNotEmpty)
                    ? NetworkImage(user.userImage.secureUrl!)
                    : null,
                child: (user.userImage.secureUrl == null ||
                        user.userImage.secureUrl!.isEmpty)
                    ? Text(
                        displayName[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: rank <= 3 ? 22 : 14,
                          color: AppPalette.primary,
                        ),
                      )
                    : null,
              ),
            ),

            const SizedBox(width: 14),

            /// 👤 Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: rank <= 3 ? 18 : 15,
                      fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Score player",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            /// 🏆 Trophy
            if (rank <= 3)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: rankColor.withOpacity(0.7),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    size: 30,
                    color: rankColor,
                  ),
                ),
              ),

            /// 🎯 Score
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppPalette.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                user.totalScore.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildRankBadge(int rank) {
  final color = getRankColor(rank);

  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    width: rank <= 3 ? 52 : 44,
    height: rank <= 3 ? 52 : 44,
    decoration: BoxDecoration(
      color: color.withOpacity(0.25),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(rank <= 3 ? 0.6 : 0.3),
          blurRadius: rank <= 3 ? 14 : 8,
          offset: const Offset(0, 4),
        ),
      ],
      gradient: rank <= 3
          ? LinearGradient(
              colors: [
                color.withOpacity(0.5),
                color.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
    ),
    alignment: Alignment.center,
    child: Text(
      rank.toString(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
        fontSize: rank <= 3 ? 20 : 16,
      ),
    ),
  );
}
