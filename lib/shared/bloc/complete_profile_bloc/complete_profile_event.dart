import '../../data/models/complete_profile/complete_profile_request.dart';

abstract class CompleteProfileEvent {}

class CompleteProfileSubmitted extends CompleteProfileEvent {
  final String track;
  final List<SkillItem> skills;

  CompleteProfileSubmitted({required this.track, required this.skills});
}
