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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final pagePadding = screenWidth * 0.04; // 4% من عرض الشاشة
    final sectionSpacing = screenHeight * 0.02; // 2% من ارتفاع الشاشة
    final bottomSpacing = screenHeight * 0.03; // 3% من ارتفاع الشاشة

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(pagePadding),
        child: Column(
          children: [
            const SettingHeader(),
            SizedBox(height: sectionSpacing),
            const PersonalInfoSection(),
            SizedBox(height: sectionSpacing),
            const AccountStatusSection(),
            SizedBox(height: sectionSpacing),
            const SubscriptionSection(),
            SizedBox(height: sectionSpacing),
            const AccountActionsSection(),
            SizedBox(height: bottomSpacing),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}
