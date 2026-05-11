class UpdateSkill {
  final String? skillName;

  UpdateSkill({this.skillName});

  factory UpdateSkill.fromJson(Map<String, dynamic>? json) {
    return UpdateSkill(
      skillName: json?['skillName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    final value = skillName?.trim();
    if (value != null && value.isNotEmpty) {
      data['skillName'] = value;
    }

    return data;
  }
}