import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final Color bgColor;
  final Color borderColor;
  final String tag;
  final Color tagColor;
  final String timeAgo;
  final String title;
  final String mentorName;
  final String sessionTime;
  final IconData icon;

  const NotificationCard({
    super.key,
    required this.bgColor,
    required this.borderColor,
    required this.tag,
    required this.tagColor,
    required this.timeAgo,
    required this.title,
    required this.mentorName,
    required this.sessionTime,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02), // بدل 18
      padding: EdgeInsets.all(16), // بدل 16
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16), // بدل 16
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Tag + Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: screenWidth * 0.045, color: tagColor,), // بدل 18
                  SizedBox(width: screenWidth * 0.01), // بدل 4
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02, // بدل 8
                      vertical: screenHeight * 0.005, // بدل 4
                    ),
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02), // بدل 8
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: tagColor,
                        fontSize: screenWidth * 0.03, // بدل 12
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                timeAgo,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.01), // بدل 8

          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),

          SizedBox(height: screenHeight * 0.005), // بدل 4

          Text(
            "Mentor: $mentorName",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall!.color,
              fontSize: screenWidth * 0.03, // بدل 12
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: screenHeight * 0.005), // بدل 4

          if (sessionTime.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: screenWidth * 0.04, // بدل 16
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
                SizedBox(width: screenWidth * 0.01), // بدل 4
                Text(
                  sessionTime,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
        ],
      ),
    );
  }
}