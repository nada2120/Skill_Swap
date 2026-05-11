
import 'package:skill_swap/shared/data/models/verify_code/verify_code_error_response.dart';
import 'package:skill_swap/shared/data/models/verify_code/verify_code_success_response.dart';

sealed class VerifyCodeResponse {}

class VerifyCodeSuccess extends VerifyCodeResponse {
  final VerifyCodeSuccessResponse data;
    VerifyCodeSuccess(this.data);
}

class VerifyCodeFailure extends VerifyCodeResponse {
  final VerifyCodeErrorResponse error;

  VerifyCodeFailure(this.error);
}
