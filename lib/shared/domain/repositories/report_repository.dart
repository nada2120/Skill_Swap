import '../../data/models/report_user/report_request.dart';
import '../../data/models/report_user/report_response.dart';

abstract class ReportRepository {
  Future<ReportResponse> report(ReportRequest request);
}
