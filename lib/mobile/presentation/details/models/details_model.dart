import '../../../../shared/data/models/user/skill_model.dart';

class SessionModel {
  final String mentorId;
  final String mentorName;
  final String mentorTrack;
  final String mentorImage;
  final String status;
  final DateTime date;
  final String time;
  final String duration;
  final String notes;
  final double rating;
  final String review;
  final String bio;
  final List<Skill> skills;

  SessionModel(
      {required this.mentorId,
      required this.mentorName,
      required this.mentorTrack,
      required this.mentorImage,
      required this.status,
      required this.date,
      required this.time,
      required this.duration,
      required this.notes,
      required this.rating,
      required this.review,
      required this.bio,
      required this.skills});
}
