import 'package:skill_swap/shared/data/models/report_user/report_error_response.dart';
import 'package:skill_swap/shared/data/models/report_user/report_success_response.dart';

sealed class ReportResponse {}

class ReportSuccess extends ReportResponse {
  final ReportSuccessResponse success;

  ReportSuccess({required this.success});
}

class ReportFailure extends ReportResponse {
  final ReportErrorResponse error;

  ReportFailure({required this.error});
}
