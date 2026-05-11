import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/common/unreal_card.dart';
import 'package:skill_swap/desktop/presentation/setting/pages/change_password.dart';
import 'package:skill_swap/desktop/presentation/sign/screens/sign_up_screen.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_event.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_state.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../shared/bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../../shared/bloc/delete_account_bloc/delete_account_event.dart';
import '../../../shared/bloc/delete_account_bloc/delete_account_state.dart';
import '../sign/screens/sign_in_screen.dart';

class DesktopSidebar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const DesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  State<DesktopSidebar> createState() => _DesktopSidebarState();
}

class _DesktopSidebarState extends State<DesktopSidebar> {
  int? tappedActionIndex;

  void _handleActionTap(int index, VoidCallback action) {
    setState(() {
      tappedActionIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        tappedActionIndex = null;
      });
    });

    action();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 220,
      color: isDark ? AppPalette.darkElevated : AppPalette.lightElevated,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<LogoutBloc, LogoutState>(
                  listener: (context, state) {
                    if (state is LogoutSuccessState) {
                      Get.snackbar('Success', state.success);
                      Get.offAll(() => const SignInDesktop());
                    } else if (state is LogoutFailureState) {
                      Get.snackbar('Error', state.error);
                    }
                  },
                ),
                BlocListener<DeleteAccountBloc, DeleteAccountState>(
                  listener: (context, state) {
                    if (state is DeleteAccountSuccessState) {
                      Get.offAll(() => const SignUpDesktop());
                    } else if (state is DeleteAccountFailureState) {
                      Get.snackbar(
                        'Error',
                        state.message,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
              child: ListView(
                children: [
                  _item(context, Icons.home, "home".tr, 0),
                  _item(context, Icons.chat, "chat".tr, 1),
                  _item(context, Icons.search, "search".tr, 2),
                  _item(context, Icons.schedule, "sessions".tr, 3),
                  _item(context, Icons.person, "profile".tr, 4),
                  _item(context, Icons.storefront_outlined, "store", 5),
                  _item(context, Icons.settings, "setting".tr, 6),
                  const Divider(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "ACCOUNT ACTIONS",
                      style: TextStyle(
                        color: isDark ? Colors.white : AppPalette.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _actionItem(
                    context,
                    icon: Icons.lock_reset,
                    title: "change_password".tr,
                    index: 7,
                    onTap: () {
                      Get.to(ChangePasswordDesktop());
                    },
                  ),
                  _actionItem(
                    context,
                    icon: Icons.logout,
                    title: "sign_out".tr,
                    index: 8,
                    onTap: () {
                      _showLogoutConfirmation(context);
                    },
                  ),
                  _actionItem(
                    context,
                    icon: Icons.delete,
                    title: "delete_account".tr,
                    index: 9,
                    onTap: () {
                      _showDeleteConfirmation(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          // const Divider(height: 16),
          // const Padding(
          //   padding: EdgeInsets.all(8),
          //   child: UnrealExperienceCard(),
          // ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String title, int index) {
    final bool active = widget.currentIndex == index;
    final Color color =
        active ? AppPalette.primary : Theme.of(context).iconTheme.color!;

    return _buildTile(
      icon: icon,
      title: title,
      color: color,
      active: active,
      onTap: () => widget.onItemSelected(index),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Log Out"),
        content:
            const Text("Are you sure you want to log out from your account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<LogoutBloc>().add(LogoutRequested());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<DeleteAccountBloc>().add(DeleteAccountSubmit());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _actionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool active = tappedActionIndex == index;
    final Color color = active ? Colors.red : Colors.grey;

    return _buildTile(
      icon: icon,
      title: title,
      color: color,
      active: active,
      onTap: () => _handleActionTap(index, onTap),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required Color color,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: active ? color.withOpacity(0.15) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
