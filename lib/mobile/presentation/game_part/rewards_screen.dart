import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/mobile/presentation/game_part/reward_card.dart';

import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';

class RewardsScreen extends StatefulWidget {
  final int myRank;

  const RewardsScreen({super.key, required this.myRank});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<StoreCubit>().getStoreItems(freeOnly: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rewards"),
      ),
      body: BlocBuilder<StoreCubit, StoreState>(
        builder: (context, state) {
          if (!state.isClaimPhase) {
            return _buildPreview(context);
          }

          if (widget.myRank > 10) {
            return const Center(
              child: Text(
                "Keep going! Reach top 10 next month",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return _buildClaim(context, state);
        },
      ),
    );
  }

  // ================= PREVIEW =================
  Widget _buildPreview(BuildContext context) {
    final cubit = context.read<StoreCubit>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RewardCard(
          rank: 1,
          preview: true,
          rewards: cubit.getRewardItemsByRank(1),
        ),
        RewardCard(
          rank: 2,
          preview: true,
          rewards: cubit.getRewardItemsByRank(2),
          // onCollect: () {
          //   cubit.collectRewards(2);
          // },
        ),
        RewardCard(
          rank: 3,
          preview: true,
          rewards: cubit.getRewardItemsByRank(3),
        ),
        RewardCard(
          range: "4-10",
          preview: true,
          rewards: cubit.getRewardItemsByRank(4),
        ),
      ],
    );
  }

  // ================= CLAIM =================
  Widget _buildClaim(BuildContext context, StoreState state) {
    final cubit = context.read<StoreCubit>();

    return Center(
      child: RewardCard(
        rank: widget.myRank <= 3 ? widget.myRank : null,
        range: widget.myRank > 3 ? "4-10" : null,
        isClaim: true,
        isClaimed: state.isClaimed,
        isLoading: state.isLoading,
        rewards: cubit.getRewardItemsByRank(widget.myRank),
        onCollect: () {
          cubit.collectRewards(widget.myRank);
        },
      ),
    );
  }
}
