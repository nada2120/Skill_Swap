import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../../mobile/presentation/game_stor/widgets/purchases_item_card.dart';
import '../../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../../shared/bloc/store_cubit/purchase_state.dart';
import '../../../../shared/data/models/store/purchase_mapper.dart';

class MyPurchasesPage extends StatelessWidget {
  const MyPurchasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => desktopKey.currentState?.goBack(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 12),
                const Text(
                  "My Purchases",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          BlocBuilder<PurchaseCubit, PurchaseState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.purchases.isEmpty) {
                return const Expanded(
                  child: Center(child: Text("No Purchases Yet")),
                );
              }

              return Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;

                    if (constraints.maxWidth > 1200) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth > 800) {
                      crossAxisCount = 3;
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.purchases.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (_, i) {
                        final purchase = state.purchases[i];

                        return PurchasesItemCard(
                          item: purchase.toStoreItem(),
                          isSelected: false,
                          onTap: () {},
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
