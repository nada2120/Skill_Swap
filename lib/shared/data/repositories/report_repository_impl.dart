import 'package:dio/dio.dart';
import 'package:skill_swap/shared/data/models/report_user/report_error_response.dart';
import 'package:skill_swap/shared/data/models/report_user/report_request.dart';
import 'package:skill_swap/shared/data/models/report_user/report_response.dart';

import '../../domain/repositories/report_repository.dart';
import '../web_services/report/report_api.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportApi api;
  final Dio dio;

  ReportRepositoryImpl({
    required this.api,
    required this.dio,
  });

  String _getServerErrorMessage(DioException e) {
    try {
      final data = e.response?.data;

      if (data != null) {
        if (data is Map<String, dynamic>) {
          if (data['message'] != null) {
            return data['message'].toString();
          }
        } else if (data is String) {
          return data;
        }
      }
    } catch (_) {}

    return e.message ?? "Network Error";
  }

  @override
  Future<ReportResponse> report(ReportRequest request) async {
    try {
      final response = await api.report(request);
      if (response.message == "Report created successfully") {
        return ReportSuccess(success: response);
      }
      return ReportFailure(
          error: ReportErrorResponse(message: response.message));
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = ReportErrorResponse.fromJson(e.response!.data);
        return ReportFailure(error: error);
      }

      return ReportFailure(
          error: ReportErrorResponse(message: _getServerErrorMessage(e)));
    }
  }
}
