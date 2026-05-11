import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';
import '../../../../shared/common_ui/error_dialog.dart';
import '../widgets/fantasy_store_header.dart';
import '../widgets/store_item_card.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String? selectedId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreCubit, StoreState>(
      listenWhen: (prev, curr) =>
          prev.successMessage != curr.successMessage ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.successMessage != null) {
          showAppDialog(
            context: context,
            message: state.successMessage!,
            type: DialogType.success,
            autoCloseDuration: const Duration(seconds: 2),
          );

          context.read<MyProfileCubit>().fetchMyProfile();
          context.read<StoreCubit>().clearMessage();
        }

        if (state.errorMessage != null) {
          showAppDialog(
            context: context,
            message: state.errorMessage!,
            type: DialogType.error,
          );

          context.read<StoreCubit>().clearMessage();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<StoreCubit, StoreState>(
            builder: (context, state) {
              return Column(
                children: [
                  const FantasyStoreHeader(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.items.isEmpty) {
                          return const Center(
                            child: Text(
                              "No items available",
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }

                        // const SizedBox(height: 10),
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: state.items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = state.items[index];

                            return StoreItemCard(
                              item: item,
                              isSelected: selectedId == item.id,
                              onTap: () {
                                setState(() {
                                  selectedId = item.id;
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //  const TimerWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
