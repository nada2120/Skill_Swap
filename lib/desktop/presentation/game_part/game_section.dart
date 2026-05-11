import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skill_swap/desktop/presentation/game_part/leaderboard_screen.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../shared/dependency_injection/injection.dart';
import '../../../main.dart';
import '../../../mobile/presentation/game_stor/widgets/show_store_daiolg.dart';

class GameSection extends StatefulWidget {
  const GameSection({super.key});

  @override
  State<GameSection> createState() => _GameSectionState();
}

class _GameSectionState extends State<GameSection> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  final box = GetStorage();

  late bool isFirst = box.read("leaderBoardFirst") ?? true;

  int _currentPage = 0;
  Timer? _timer;

  static const Color primaryColor = Color(0xFF3F51B5);

  final List<String> images = [
    "assets/images/leaderboard_images/image1.jpeg",
    "assets/images/leaderboard_images/image2.jpeg",
    "assets/images/leaderboard_images/image3.jpeg",
    "assets/images/leaderboard_images/image4.jpeg",
    "assets/images/leaderboard_images/image5.jpeg",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Our Game",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton.icon(
                  onPressed: () {
                    desktopKey.currentState?.openSidePage(
                      body: BlocProvider(
                        create: (_) => sl<UsersCubit>(),
                        child: Builder(
                          builder: (context) {
                            if (isFirst) {
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  showStoreDialog(
                                    context,
                                    isFirstTime: true,
                                    title: "Leaderboard",
                                    subtitle: "leaderboard",
                                    rules:
                                        "• Only the Top 10 players are displayed on the leaderboard\n"
                                        "• Your score is based on your performance in the Challenge Rooms.\n"
                                        "• The leaderboard resets at the beginning of each month, and rewards are distributed based on the final ranking before reset.\n"
                                        "• If the user doesn’t claim their reward within 1 hour, it will be automatically collected and credited to their account.\n",
                                  );
                                  box.write("leaderBoardFirst", false);
                                  isFirst = false;
                                },
                              );
                            }

                            return LeaderboardScreen(onBack: () {
                              final didGoBack =
                                  desktopKey.currentState?.goBack();
                              if (didGoBack == false) {
                                desktopKey.currentState?.openPage(index: 0);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.emoji_events, color: primaryColor),
                  label: Text(
                    "View Leaderboard",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            /// Carousel
            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _controller,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final bool isActive = index == _currentPage;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: isActive ? 10 : 25,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (isActive)
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Indicator
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: images.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: primaryColor,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
