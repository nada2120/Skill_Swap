import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final String title;
  final String value;

  const InfoField(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final verticalPadding = screenHeight * 0.008; // 0.8% من ارتفاع الشاشة
    final containerPadding = screenWidth * 0.03; // 3% من عرض الشاشة
    final borderRadius = screenWidth * 0.02; // 2% من عرض الشاشة

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: screenHeight * 0.005), // فاصل ديناميكي
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(containerPadding),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const StatusRow(this.title, this.value, {this.valueColor, super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalPadding = screenHeight * 0.004; // 0.4% من ارتفاع الشاشة

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: TextStyle(color: valueColor)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.04; // 4% من عرض الشاشة

    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
    );
  }
}

BoxDecoration boxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.indigo),
  );
}
