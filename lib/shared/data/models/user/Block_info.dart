class BlockInfo {
  final bool isBlocked;
  final String? blockReason;

  BlockInfo({required this.isBlocked, this.blockReason});

  Map<String, dynamic> toJson() {
    return {"isBlocked": isBlocked, "blockReason": blockReason};
  }

  factory BlockInfo.empty() {
    return BlockInfo(isBlocked: false, blockReason: "");
  }

  factory BlockInfo.fromJson(Map<String, dynamic> json) {
    return BlockInfo(
      isBlocked: json['isBlocked'] ?? false,
      blockReason: json['blockReason'] ?? '',
    );
  }
}
