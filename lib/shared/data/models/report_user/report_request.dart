import 'package:json_annotation/json_annotation.dart';

part 'report_request.g.dart';

@JsonSerializable()
class ReportRequest {
  final String reason;
  final String reportedUser;

  ReportRequest({
    required this.reason,
    required this.reportedUser,
  });

  Map<String, dynamic> toJson() => _$ReportRequestToJson(this);
}
