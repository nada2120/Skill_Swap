import 'package:flutter/material.dart';

import 'info_field.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle("Personal Information"),
          InfoField("Full Name", "Liyan Alex"),
          InfoField("Email", "liyanAlex@gmail.com"),
          InfoField("Bio", "Tell others about yourself"),
          InfoField("Skills", "JavaScript, React"),
        ],
      ),
    );
  }
}