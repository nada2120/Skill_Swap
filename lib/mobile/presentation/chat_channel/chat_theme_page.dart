import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../shared/bloc/store_cubit/purchase_state.dart';

class ChatThemePage extends StatefulWidget {
  const ChatThemePage({super.key});

  @override
  State<ChatThemePage> createState() => _ChatThemePageState();
}

class _ChatThemePageState extends State<ChatThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Theme")),
      body: BlocBuilder<PurchaseCubit, PurchaseState>(
        builder: (context, purchaseState) {
          if (purchaseState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final themes =
              purchaseState.purchases.where((p) => p.type == "theme").toList();

          return BlocBuilder<MyProfileCubit, MyProfileState>(
            builder: (context, profileState) {
              final activeThemeValue = profileState is MyProfileLoaded
                  ? profileState.profile.activeTheme?.value
                  : null;

              final groupValue = activeThemeValue ?? "default";

              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  /// ✅ Default Theme
                  RadioListTile<String>(
                    title: const Text("Default Theme"),
                    value: "default",
                    groupValue: groupValue,
                    onChanged: (val) {
                      context
                          .read<MyProfileCubit>()
                          .setActiveTheme(null); // 👈 الصح
                    },
                  ),

                  const Divider(),

                  ...themes.map((theme) {
                    final value = theme.itemId?.value ?? "";
                    final themeId = theme.itemId?.id ?? "";
                    final image = theme.itemId?.img?.secureUrl ?? "";

                    return RadioListTile<String>(
                      value: value,
                      groupValue: groupValue,
                      onChanged: (val) {
                        if (val != null) {
                          context
                              .read<MyProfileCubit>()
                              .setActiveTheme(themeId);
                        }
                      },
                      title: Text(theme.itemId?.title ?? ""),
                      subtitle: Text(value),
                      secondary: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: image.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: image.isEmpty
                            ? const Icon(Icons.image, size: 20)
                            : null,
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
