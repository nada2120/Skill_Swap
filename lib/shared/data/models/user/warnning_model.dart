class WarningModel {
  final String reason;
  final String issuedBy;
  final String issuedAt;

  WarningModel({
    required this.reason,
    required this.issuedBy,
    required this.issuedAt,
  });

  Map<String, dynamic> toJson() {
    return {"reason": reason, "issuedBy": issuedBy, "issuedAt": issuedAt};
  }

  factory WarningModel.fromJson(Map<String, dynamic>? json) {
    return WarningModel(
      reason: json?['reason'] ?? '',
      issuedBy: json?['issuedBy'] ?? '',
      issuedAt: json?['issuedAt'] ?? '',
    );
  }
}
