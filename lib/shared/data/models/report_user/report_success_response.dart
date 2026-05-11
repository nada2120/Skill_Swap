part 'report_success_response.g.dart';

class ReportSuccessResponse {
  final String message;

  ReportSuccessResponse({required this.message});

  factory ReportSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReportSuccessResponseToJson(this);
}
