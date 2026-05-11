import 'package:flutter/material.dart';
import 'package:skill_swap/mobile/presentation/setting/widgets/personal_inf.dart';
import 'package:skill_swap/mobile/presentation/setting/widgets/sign_out.dart';
import 'package:skill_swap/mobile/presentation/setting/widgets/subcription.dart';
import 'account_statue.dart';
import 'delete.dart';
import 'header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            SettingHeader(),
            SizedBox(height: 16),
            PersonalInfoSection(),
            SizedBox(height: 16),
            AccountStatusSection(),
            SizedBox(height: 16),
            SubscriptionSection(),
            SizedBox(height: 16),
            AccountActionsSection(),
            SizedBox(height: 24),
            SignOutButton(),
          ],
        ),
      ),
    );
  }
}