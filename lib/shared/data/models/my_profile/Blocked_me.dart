import 'package:equatable/equatable.dart';

class BlockedMe extends Equatable {
  final String? blockedUntil;
  final String blockReason;
  final bool isBlocked;

  BlockedMe({
    this.blockedUntil,
    required this.blockReason,
    required this.isBlocked,
  });

  @override
  List<Object?> get props => [blockedUntil, blockReason, isBlocked];

  factory BlockedMe.fromJson(Map<String, dynamic> json) {
    return BlockedMe(
      blockedUntil: json['blockedUntil'] ?? '',
      blockReason: json['blockReason'] ?? '',
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockedUntil': blockedUntil,
      'blockReason': blockReason,
      'isBlocked': isBlocked,
    };
  }

  factory BlockedMe.empty() {
    return BlockedMe(blockReason: "", isBlocked: false);
  }
}
