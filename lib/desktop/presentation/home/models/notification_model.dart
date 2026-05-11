import 'package:flutter/material.dart';

class NotificationModel {
  final Color bgColor;
  final Color borderColor;
  final String tag;
  final Color tagColor;
  final String timeAgo;
  final String title;
  final String mentorName;
  final String sessionTime;
  final IconData icon;
  final DateTime dateTime;

  const NotificationModel(
      {required this.bgColor,
      required this.borderColor,
      required this.tag,
      required this.tagColor,
      required this.timeAgo,
      required this.title,
      required this.mentorName,
      required this.sessionTime,
      required this.icon,
      required this.dateTime});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        bgColor: json['bgColor'],
        borderColor: json['borderColor'],
        tag: json['tag'],
        tagColor: json['tagColor'],
        timeAgo: json['timeAgo'],
        title: json['title'],
        mentorName: json['mentorName'],
        sessionTime: json['sessionTime'],
        icon: json['icon'],
        dateTime: json['dateTime']);
  }
}
