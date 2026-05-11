import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../../shared/bloc/store_cubit/purchase_state.dart';
import '../../../../shared/data/models/store/purchase_mapper.dart';
import '../widgets/purchases_item_card.dart';

class MyPurchasesScreen extends StatelessWidget {
  const MyPurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "My Purchases",
      child: BlocBuilder<PurchaseCubit, PurchaseState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.purchases.isEmpty) {
            return const Center(child: Text("No Purchases Yet"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.purchases.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
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
  }
}
