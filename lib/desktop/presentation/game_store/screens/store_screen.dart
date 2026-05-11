import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../mobile/presentation/game_stor/widgets/fantasy_store_header.dart';
import '../../../../mobile/presentation/game_stor/widgets/store_item_card.dart';
import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';
import '../../../../shared/common_ui/error_dialog.dart';
import '../../../../shared/dependency_injection/injection.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String? selectedId;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StoreCubit>()..getStoreItems(freeOnly: false),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<StoreCubit, StoreState>(
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

                context.read<StoreCubit>().clearMessage();
              }

              // ❌ ERROR DIALOG
              if (state.errorMessage != null) {
                showAppDialog(
                  context: context,
                  message: state.errorMessage!,
                  type: DialogType.error,
                );

                context.read<StoreCubit>().clearMessage();
              }
            },
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

                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: state.items.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 2,
                          ),
                          itemBuilder: (_, i) {
                            final item = state.items[i];

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
