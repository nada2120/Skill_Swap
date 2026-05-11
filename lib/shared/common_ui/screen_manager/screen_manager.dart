import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skill_swap/mobile/presentation/game_stor/screens/store_screen.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';
import 'package:skill_swap/shared/bloc/track_cubit/track_cubit.dart';

import '../../../mobile/presentation/chat_channel/chat_list.dart';
import '../../../mobile/presentation/game_stor/widgets/show_store_daiolg.dart';
import '../../../mobile/presentation/home/screens/home_screen.dart';
import '../../../mobile/presentation/profile/screens/profile_screen.dart';
import '../../../mobile/presentation/search/screens/search_screen.dart';
import '../../../mobile/presentation/sessions/screens/sessions_screen.dart';
import '../../bloc/cancel_book_bloc/cancel_book_bloc.dart';
import '../../bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../bloc/private_chats_bloc/private_chats_bloc.dart';
import '../../bloc/public_chat/public_chat_bloc.dart';
import '../../bloc/public_chat/public_chat_event.dart';
import '../../bloc/report_bloc/report_bloc.dart';
import '../../bloc/status_book_bloc/status_book_bloc.dart';
import '../../bloc/store_cubit/purchase_cubit.dart';
import '../../bloc/store_cubit/store_cubit.dart';
import '../../bloc/tracks_bloc/tracks_bloc.dart';
import '../../bloc/tracks_bloc/tracks_event.dart';
import '../../bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../core/network/pusher_service.dart';
import '../../dependency_injection/injection.dart';
import '../../helper/local_storage.dart';
import '../custom_bottom_nav.dart';
import '../session_end_dialog.dart';

class ScreenManager extends StatefulWidget {
  final int initialIndex;
  final int initialSessionTab;
  final int initialProfileTab;
  final num? noUserPrice;
  final String? noUserBookingCode;
  final bool? isStudent;
  final bool showNoUserDialog;

  const ScreenManager(
      {super.key,
      this.initialIndex = 0,
      this.initialSessionTab = 0,
      this.initialProfileTab = 0,
      this.noUserPrice,
      this.noUserBookingCode,
      this.isStudent,
      this.showNoUserDialog = false});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _initPusher();
    if (widget.showNoUserDialog) {
      Future.delayed(Duration.zero, () {
        _showSessionEndDialog(
            price: widget.noUserPrice ?? 0,
            bookingCode: widget.noUserBookingCode ?? '',
            isStudent: widget.isStudent ?? false);
      });
    }
  }

  void _showSessionEndDialog({
    required num price,
    required String bookingCode,
    required bool isStudent,
  }) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return BlocProvider(
          create: (_) => sl<ReportBloc>(),
          child: SessionEndDialog(
            price: price,
            bookingCode: bookingCode,
            isStudent: isStudent,
          ),
        );
      },
    );
  }

  Future<void> _initPusher() async {
    final userId = await LocalStorage.getUserId();
    if (userId != null && userId.isNotEmpty) {
      await sl<PusherService>().init(userId: userId);
    }
  }

  late final List<Widget> screens = [
    MultiBlocProvider(providers: [
      // BlocProvider<MyProfileCubit>(
      //   create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
      // ),
      BlocProvider<UsersCubit>(
        create: (_) => sl<UsersCubit>(),
      ),
      BlocProvider<GetBookingsCubit>(create: (_) => sl<GetBookingsCubit>()),
      BlocProvider<PrivateChatsBloc>(create: (_) => sl<PrivateChatsBloc>())
    ], child: HomeScreen()),
    MultiBlocProvider(providers: [
      BlocProvider(create: (_) => sl<TracksBloc>()..add(LoadTracksEvent())),
      BlocProvider(
          create: (_) => sl<PublicChatBloc>()..add(GetPublicChatsEvent())),
      BlocProvider(
        create: (_) => sl<PurchaseCubit>(),
      )
    ], child: ChatListScreen()),
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => sl<UserFilterBloc>(),
      ),
      BlocProvider(
        create: (_) => sl<TracksCubit>(),
      ),
    ], child: SearchScreen()),
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                sl<GetBookingsCubit>()..fetchAllBookings("accepted")),
        BlocProvider(create: (_) => sl<StatusBookBloc>()),
        BlocProvider(create: (_) => sl<CancelBookBloc>()),
        BlocProvider(create: (_) => sl<PurchaseCubit>()..getAvailableVouchers())
      ],
      child: SessionsScreen(
        initialTab: widget.initialSessionTab,
      ),
    ),
    ProfileScreen(
      initialTab: widget.initialProfileTab,
    ),
    BlocProvider(
      create: (_) => sl<StoreCubit>()..getStoreItems(freeOnly: false),
      child: StoreScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: SizedBox.expand(
        child: IndexedStack(
          index: currentIndex,
          children: screens.map((screen) {
            return SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: screen,
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
          selectedIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;

              // 👇 لو دخلنا على Sessions نرجّعها دايمًا لـ Accepted
              if (index == 3) {
                screens[3] = MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          sl<GetBookingsCubit>()..fetchAllBookings("accepted"),
                    ),
                    BlocProvider(create: (_) => sl<StatusBookBloc>()),
                    BlocProvider(
                      create: (_) =>
                          sl<PurchaseCubit>()..getAvailableVouchers(),
                    ),
                  ],
                  child: const SessionsScreen(
                    initialTab: 0, // 👈 هنا بترجعيه لأول تاب
                  ),
                );
              }
            });

            // 👇 اللوجيك بتاع الـ Store زي ما هو
            if (index == 5) {
              final box = GetStorage();
              bool isFirst = box.read("storeFirst") ?? true;

              if (isFirst) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  showStoreDialog(
                    context,
                    isFirstTime: true,
                    title: "Skill Swap Store",
                    subtitle: "score",
                    rules: "• Store items are refreshed every Saturday.\n"
                        "• Earn points by completing Challenge Rooms.\n"
                        "• Some items can only be purchased once, while others refresh weekly.\n",
                  );
                });
                box.write("storeFirst", false);
              }
            }
          }),
    );
  }
}
