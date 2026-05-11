import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/report_user/report_request.dart';
import '../../models/report_user/report_success_response.dart';

part 'report_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/")
abstract class ReportApi {
  factory ReportApi(Dio dio, {String baseUrl}) = _ReportApi;

  @POST("report")
  Future<ReportSuccessResponse> report(@Body() ReportRequest body);
}
