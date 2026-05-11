import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/complete_profile/complete_profile_request.dart';
import '../../models/login/login_request.dart';
import '../../models/login/login_success_response_new.dart';
import '../../models/logout/logout_response.dart';
import '../../models/register/register_request.dart';
import '../../models/register/register_success_response.dart';
import '../../models/reset_password/reset_password_request.dart';
import '../../models/reset_password/reset_password_success_response.dart';
import '../../models/send_code/send_code_request.dart';
import '../../models/send_code/send_code_success_response.dart';
import '../../models/verify_code/verify_code_request.dart';
import '../../models/verify_code/verify_code_success_response.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/auth/")
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST("register/")
  Future<RegisterSuccessResponse> register(@Body() RegisterRequest body);

  @POST("login/")
  Future<LoginSuccessResponseNew> login(@Body() LoginRequest body);

  @POST("password/forgot/")
  Future<SendCodeSuccessResponse> sendCode(@Body() SendCodeRequest body);

  @POST("password/verify-code/")
  Future<VerifyCodeSuccessResponse> verifyCode(@Body() VerifyCodeRequest body);

  @PATCH("password/reset/")
  Future<ResetPasswordSuccessResponse> resetPassword(
    @Body() ResetPasswordRequest body,
  );

  @POST("logout/")
  Future<LogoutResponse> logout();

  @POST("activation/verify")
  Future<dynamic> verifyActivation(@Body() Map<String, dynamic> body);

  @POST("activation/resend")
  Future<dynamic> resendActivation(@Body() Map<String, dynamic> body);

  @POST("complete-profile")
  Future<dynamic> completeProfile(@Body() CompleteProfileRequest body);

  @GET("tracks")
  Future<dynamic> getTracks();
}
