import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../shared/bloc/public_chat/public_chat_bloc.dart';
import '../../../shared/bloc/public_chat/public_chat_event.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_state.dart';
import '../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../shared/bloc/tracks_bloc/tracks_bloc.dart';
import '../../../shared/bloc/tracks_bloc/tracks_event.dart';
import '../../../shared/bloc/tracks_bloc/tracks_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/public_chat/get_chat_model.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../../../shared/helper/local_storage.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, String> joinedChats = {};
  final Set<String> _leavingTracks = {};
  final Set<String> _joiningTracks = {};
  final Set<String> _shownJoinDialogForTrack = {};
  bool _dialogLoaded = false;

  String? selectedChannel;
  String? selectedTrackId;
  String searchQuery = "";
  String? currentUserId;
  bool _dataLoaded = false;

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnim;

  Future<void> _loadDialogFlags() async {
    final list = await LocalStorage.getShownDialogs() ?? [];
    _shownJoinDialogForTrack.addAll(list);
    _dialogLoaded = true;
    setState(() {});
  }

  Future<void> _saveDialogFlags() async {
    await LocalStorage.saveShownDialogs(
      _shownJoinDialogForTrack.toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadDialogFlags();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _shimmerAnim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    context.read<TracksBloc>().add(LoadTracksEvent());
    context.read<PublicChatBloc>().add(GetPublicChatsEvent());
    context.read<PurchaseCubit>().getPurchases();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    currentUserId = await LocalStorage.getUserId();
    setState(() {});
  }

  void _showLeaveConfirmation(
      String chatId, String channelName, String trackId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Channel'),
        content: Text('Are you sure you want to leave "$channelName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _leavingTracks.add(trackId));
              context.read<TracksBloc>().add(LeaveChatEvent(chatId));
            },
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openChat(String chatId, String channel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<PublicChatMessagesCubit>()),
          ],
          child: ChatScreen(chatId: chatId, channelName: channel),
        ),
      ),
    );
    if (mounted) {
      context.read<PublicChatBloc>().add(GetPublicChatsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        BlocListener<TracksBloc, TracksState>(
          listener: (context, state) {
            if (state is JoinTracksSuccess) {
              final chatId = state.success.success.chatDetails.id;
              setState(() {
                _joiningTracks.remove(selectedTrackId);
                joinedChats[selectedTrackId!] = chatId;
              });
              _openChat(chatId, selectedChannel!);
            }

            if (state is JoinTracksError) {
              setState(() => _joiningTracks.remove(selectedTrackId));
              Get.snackbar(
                "Error",
                state.error.error.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            }

            if (state is LeaveChatSuccess) {
              setState(() {
                _leavingTracks.remove(selectedTrackId);
                joinedChats.remove(selectedTrackId);
              });
              Get.snackbar(
                "Success",
                "You left the channel successfully",
                snackPosition: SnackPosition.BOTTOM,
              );
              // context.read<TracksBloc>().add(LoadTracksEvent());
              context.read<PublicChatBloc>().add(GetPublicChatsEvent());
            }

            if (state is LeaveChatError) {
              setState(() => _leavingTracks.remove(selectedTrackId));
              Get.snackbar(
                "Error",
                state.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            }

            if (state is JoinTracksLoaded) {
              _dataLoaded = true;
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text("Channels"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                /// Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search".tr,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),

                /// Channels list
                Expanded(
                  child: BlocBuilder<TracksBloc, TracksState>(
                    builder: (context, trackState) {
                      if (trackState is JoinTracksLoading && !_dataLoaded) {
                        return AnimatedBuilder(
                          animation: _shimmerAnim,
                          builder: (_, __) => ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (_, __) => ChannelLoadingCard(
                              shimmerValue: _shimmerAnim.value,
                              isDark: isDark,
                            ),
                          ),
                        );
                      }

                      if (trackState is JoinTracksLoaded) {
                        final tracks = trackState.tracks;
                        final publicChatState =
                            context.watch<PublicChatBloc>().state;
                        final publicChats = publicChatState is PublicChatsLoaded
                            ? publicChatState.chats.chats
                            : <dynamic>[];

                        final filteredTracks = tracks
                            .where((track) =>
                                track.name!.toLowerCase().contains(searchQuery))
                            .toList();

                        return ListView.builder(
                          itemCount: filteredTracks.length,
                          itemBuilder: (context, index) {
                            final track = filteredTracks[index];

                            final chat =
                                publicChats.cast<GetChatModel?>().firstWhere(
                                      (c) =>
                                          c != null && c.track?.id == track.id,
                                      orElse: () => null,
                                    );

                            bool isJoined =
                                chat?.isJoined(currentUserId ?? "") ?? false;
                            String? chatId = chat?.id;

                            if (joinedChats.containsKey(track.id)) {
                              isJoined = true;
                              chatId = joinedChats[track.id];
                            }

                            final isSelected = track.name == selectedChannel;
                            final isLeaving = _leavingTracks.contains(track.id);
                            final isJoining = _joiningTracks.contains(track.id);

                            return InkWell(
                              onTap: (!isJoined &&
                                      _shownJoinDialogForTrack
                                          .contains(track.id))
                                  ? null
                                  : () async {
                                      if (!isJoined) {
                                        final id = track.id!;

                                        if (!_shownJoinDialogForTrack
                                            .contains(id)) {
                                          _shownJoinDialogForTrack.add(id);
                                          await _saveDialogFlags();

                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title:
                                                  const Text("Join Required"),
                                              content: Text(
                                                "Join '${track.name}' to access this channel",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        return;
                                      }

                                      if (chatId != null) {
                                        selectedChannel = track.name;
                                        selectedTrackId = track.id;
                                        _openChat(chatId, track.name!);
                                      }
                                    },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.007),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark
                                          ? AppPalette.primary
                                              .withValues(alpha: 0.5)
                                          : const Color(0xFFE6E7FF))
                                      : Theme.of(context).cardColor,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppPalette.primary
                                        : Theme.of(context).dividerColor,
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: isSelected
                                              ? AppPalette.primary
                                              : const Color(0XFFF2F5F8),
                                          child: Text(
                                            track.name![0],
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppPalette.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.03),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      track.name ?? "",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .color,
                                                      ),
                                                    ),
                                                  ),

                                                  /// Join button
                                                  if (!isJoined)
                                                    ElevatedButton(
                                                      onPressed: isJoining
                                                          ? null
                                                          : () {
                                                              selectedChannel =
                                                                  track.name;
                                                              selectedTrackId =
                                                                  track.id;
                                                              setState(() =>
                                                                  _joiningTracks
                                                                      .add(track
                                                                          .id!));
                                                              context
                                                                  .read<
                                                                      TracksBloc>()
                                                                  .add(JoinTrackEvent(
                                                                      track
                                                                          .id!));
                                                            },
                                                      child: isJoining
                                                          ? const SizedBox(
                                                              width: 16,
                                                              height: 16,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : const Text("Join"),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(track.description ?? ""),

                                              /// Open + Leave buttons
                                              if (isJoined &&
                                                  chatId != null) ...[
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        selectedChannel =
                                                            track.name;
                                                        selectedTrackId =
                                                            track.id;
                                                        _openChat(chatId!,
                                                            track.name!);
                                                      },
                                                      child: const Text("Open"),
                                                    ),
                                                    const SizedBox(width: 8),

                                                    /// Leave button
                                                    OutlinedButton(
                                                      onPressed: isLeaving
                                                          ? null
                                                          : () {
                                                              selectedChannel =
                                                                  track.name;
                                                              selectedTrackId =
                                                                  track.id;
                                                              _showLeaveConfirmation(
                                                                chatId!,
                                                                track.name!,
                                                                track.id!,
                                                              );
                                                            },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.red,
                                                        side: const BorderSide(
                                                            color: Colors.red),
                                                      ),
                                                      child: isLeaving
                                                          ? const SizedBox(
                                                              width: 16,
                                                              height: 16,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            )
                                                          : const Text("Leave"),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// ChannelLoadingCard مع Shimmer Animation
// =========================================================
class ChannelLoadingCard extends StatelessWidget {
  final double shimmerValue;
  final bool isDark;

  const ChannelLoadingCard({
    super.key,
    required this.shimmerValue,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final base = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
    final highlight =
        isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5);

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Shimmer(
                width: 44,
                height: 44,
                radius: 22,
                value: shimmerValue,
                base: base,
                highlight: highlight,
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Shimmer(
                      width: screenWidth * 0.38,
                      height: 13,
                      radius: 6,
                      value: shimmerValue,
                      base: base,
                      highlight: highlight,
                    ),
                    const SizedBox(height: 8),
                    _Shimmer(
                      width: double.infinity,
                      height: 10,
                      radius: 5,
                      value: shimmerValue,
                      base: base,
                      highlight: highlight,
                    ),
                    const SizedBox(height: 5),
                    _Shimmer(
                      width: screenWidth * 0.5,
                      height: 10,
                      radius: 5,
                      value: shimmerValue,
                      base: base,
                      highlight: highlight,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _Shimmer(
                width: 62,
                height: 34,
                radius: 8,
                value: shimmerValue,
                base: base,
                highlight: highlight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Shimmer(
                width: 72,
                height: 32,
                radius: 8,
                value: shimmerValue,
                base: base,
                highlight: highlight,
              ),
              const SizedBox(width: 8),
              _Shimmer(
                width: 72,
                height: 32,
                radius: 8,
                value: shimmerValue,
                base: base,
                highlight: highlight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double value;
  final Color base;
  final Color highlight;

  const _Shimmer({
    required this.width,
    required this.height,
    required this.radius,
    required this.value,
    required this.base,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: [
                (value - 0.8).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 0.8).clamp(0.0, 1.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
