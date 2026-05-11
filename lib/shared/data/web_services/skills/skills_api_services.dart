import 'package:dio/dio.dart';

import '../../models/track/skills_response.dart';

class SkillsApiService {
  final Dio dio;

  static const String _baseUrl = 'https://skill-swaapp.vercel.app';

  SkillsApiService(this.dio);

  Future<SkillsResponse> getSkills(String trackId) async {
    try {
      final response = await dio.get(
        '$_baseUrl/admin/skills',
        queryParameters: {
          'trackId': trackId,
        },
      );

      return SkillsResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
