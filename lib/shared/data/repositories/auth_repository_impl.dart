import 'package:dio/dio.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../helper/local_storage.dart';
import '../models/complete_profile/complete_profile_request.dart';
import '../models/complete_profile/complete_profile_response.dart';
import '../models/login/login_error_response.dart';
import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import '../models/logout/logout_response.dart';
import '../models/register/register_error_response.dart';
import '../models/register/register_request.dart';
import '../models/register/register_response.dart';
import '../models/reset_password/reset_password_error_response.dart';
import '../models/reset_password/reset_password_request.dart';
import '../models/reset_password/reset_password_response.dart';
import '../models/send_code/send_code_error_response.dart';
import '../models/send_code/send_code_request.dart';
import '../models/send_code/send_code_response.dart';
import '../models/track/track_model.dart';
import '../models/verify_code/verify_code_error_response.dart';
import '../models/verify_code/verify_code_request.dart';
import '../models/verify_code/verify_code_response.dart';
import '../web_services/auth/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  final Dio dio;

  AuthRepositoryImpl({required this.api, required this.dio});

  String _getServerErrorMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        } else if (data is String) {
          return data;
        }
      }
    } catch (_) {}
    return e.message ?? "Network Error";
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await api.register(request);
      if (response.message ==
          "User Registered Successfully. Please check you email for activation code") {
        return RegisterSuccess(response);
      }
      return RegisterFailure(RegisterErrorResponse(message: response.message));
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = RegisterErrorResponse.fromJson(e.response!.data);
        return RegisterFailure(error);
      }

      return RegisterFailure(
        RegisterErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return RegisterFailure(
        RegisterErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await api.login(request);
      if (response.message == "User Login Successfully") {
        return LoginSuccess(response);
      }
      return LoginFailure(LoginErrorResponse(message: response.message));
    } on DioException catch (e) {
      final msg = _getServerErrorMessage(e);
      return LoginFailure(LoginErrorResponse(message: msg));
    } catch (e) {
      return LoginFailure(LoginErrorResponse(message: e.toString()));
    }
  }

  @override
  Future<SendCodeResponse> sendCode(SendCodeRequest request) async {
    try {
      final response = await api.sendCode(request);
      if (response.message == "Verification Code Sent Successfully") {
        return SendCodeSuccess(response);
      }
      return SendCodeFailure(SendCodeErrorResponse(message: response.message));
    } on DioException catch (e) {
      return SendCodeFailure(
        SendCodeErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return SendCodeFailure(
        SendCodeErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request) async {
    try {
      final response = await api.verifyCode(request);
      if (response.message == "Code Verified Successfully") {
        return VerifyCodeSuccess(response);
      }
      return VerifyCodeFailure(
        VerifyCodeErrorResponse(message: response.message),
      );
    } on DioException catch (e) {
      return VerifyCodeFailure(
        VerifyCodeErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return VerifyCodeFailure(VerifyCodeErrorResponse(message: e.toString()));
    }
  }

  @override
  Future<ResetPasswordResponse> resetPassword(
      ResetPasswordRequest request) async {
    try {
      final response = await api.resetPassword(request);
      if (response.message == 'Password Changed Successfully') {
        return ResetPasswordSuccess(response);
      }
      return ResetPasswordFailure(
        ResetPasswordErrorResponse(message: response.message),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = ResetPasswordErrorResponse.fromJson(e.response!.data);
        return ResetPasswordFailure(error);
      }

      return ResetPasswordFailure(
        ResetPasswordErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return ResetPasswordFailure(
        ResetPasswordErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<void> verifyActivation(String code, String email) async {
    try {
      final trimmedCode = code.trim();
      final body = {
        'activationCode': trimmedCode,
        'email': email.trim(),
      };
      print('🔵 [verifyActivation] Sending body: $body');
      final response = await api.verifyActivation(body);
      print('🟢 [verifyActivation] Response: $response');
    } on DioException catch (e) {
      print(
          '🔴 [verifyActivation] DioException status: ${e.response?.statusCode}');
      print('🔴 [verifyActivation] DioException data: ${e.response?.data}');
      throw _getServerErrorMessage(e);
    } catch (e) {
      print('🔴 [verifyActivation] Unexpected error: $e');
      throw e.toString();
    }
  }

  @override
  Future<void> resendActivation(String email) async {
    try {
      await api.resendActivation({'email': email});
    } on DioException catch (e) {
      throw _getServerErrorMessage(e);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<CompleteProfileResponse> completeProfile(
      CompleteProfileRequest request) async {
    try {
      final token = await LocalStorage.getToken();
      print('🔵 [completeProfile] Token present: ${token != null}');
      print(
          '🔵 [completeProfile] Token: ${token != null ? '${token.substring(0, 20)}...' : 'NULL'}');
      print('🔵 [completeProfile] Request body: ${request.toJson()}');

      final response = await api.completeProfile(request);
      print('🟢 [completeProfile] Response: $response');
      final message = response is Map && response['message'] != null
          ? response['message'].toString()
          : 'Profile completed successfully';
      return CompleteProfileSuccess(message);
    } on DioException catch (e) {
      print(
          '🔴 [completeProfile] DioException status: ${e.response?.statusCode}');
      print('🔴 [completeProfile] DioException data: ${e.response?.data}');
      print('🔴 [completeProfile] Request URL: ${e.requestOptions.uri}');
      print(
          '🔴 [completeProfile] Request headers: ${e.requestOptions.headers}');
      return CompleteProfileFailure(_getServerErrorMessage(e));
    } catch (e) {
      print('🔴 [completeProfile] Unexpected error: $e');
      return CompleteProfileFailure(e.toString());
    }
  }

  @override
  Future<List<TrackModel>> fetchTracks() async {
    try {
      final response = await api.getTracks();
      print('🟢 [fetchTracks] Response: $response');

      if (response is List) {
        return response
            .map((e) => TrackModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      // If response is a Map with a 'tracks' key
      if (response is Map && response['tracks'] is List) {
        return (response['tracks'] as List)
            .map((e) => TrackModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      print('🔴 [fetchTracks] DioException: ${e.response?.data}');
      throw _getServerErrorMessage(e);
    } catch (e) {
      print('🔴 [fetchTracks] Unexpected error: $e');
      throw e.toString();
    }
  }

  @override
  Future<LogoutResponse> logout() async {
    try {
      final response = await api.logout();

      if (response.message == "User Logout Successfully") {
        await LocalStorage.clearAllTokens();
        return LogoutSuccess(success: response.message);
      } else {
        return LogoutFailure(error: response.message);
      }
    } on DioException catch (e) {
      final errorMessage = _getServerErrorMessage(e);
      return LogoutFailure(error: errorMessage);
    }
  }
}
