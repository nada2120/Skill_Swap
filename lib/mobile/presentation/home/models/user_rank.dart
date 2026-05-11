import '../../../../shared/data/models/user/user_model.dart';

List<UserModel> rankRecommendedUsers(List<UserModel> users, String? track) {
  // 1. فلترة التراك (اختياري)
  final filtered = users.where((u) {
    if (track == null || track.isEmpty) return true;
    return u.track.name.toLowerCase() == track.toLowerCase();
  }).toList();

  // 2. Sorting: rating + helped hours
  filtered.sort((a, b) {
    final rateA = a.rate ?? 0;
    final rateB = b.rate ?? 0;

    final hoursA = a.helpTotalHours ?? 0;
    final hoursB = b.helpTotalHours ?? 0;

    // الأول: أعلى rating
    final rateCompare = rateB.compareTo(rateA);
    if (rateCompare != 0) return rateCompare;

    // الثاني: أعلى helped hours
    return hoursB.compareTo(hoursA);
  });

  return filtered;
}
