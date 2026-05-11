import 'package:skill_swap/shared/data/models/logout/logout_response.dart';

import '../../data/models/complete_profile/complete_profile_request.dart';
import '../../data/models/complete_profile/complete_profile_response.dart';
import '../../data/models/login/login_request.dart';
import '../../data/models/login/login_response.dart';
import '../../data/models/register/register_request.dart';
import '../../data/models/register/register_response.dart';
import '../../data/models/reset_password/reset_password_request.dart';
import '../../data/models/reset_password/reset_password_response.dart';
import '../../data/models/send_code/send_code_request.dart';
import '../../data/models/send_code/send_code_response.dart';
import '../../data/models/track/track_model.dart';
import '../../data/models/verify_code/verify_code_request.dart';
import '../../data/models/verify_code/verify_code_response.dart';

abstract class AuthRepository {
  Future<RegisterResponse> register(RegisterRequest request);

  Future<LoginResponse> login(LoginRequest request);

  Future<SendCodeResponse> sendCode(SendCodeRequest request);

  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request);

  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request);

  Future<LogoutResponse> logout();

  Future<void> verifyActivation(String code, String email);

  Future<void> resendActivation(String email);

  Future<CompleteProfileResponse> completeProfile(
      CompleteProfileRequest request);

  Future<List<TrackModel>> fetchTracks();
}
