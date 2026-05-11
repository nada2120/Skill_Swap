
import 'package:skill_swap/shared/data/models/send_code/send_code_error_response.dart';
import 'package:skill_swap/shared/data/models/send_code/send_code_success_response.dart';

sealed class SendCodeResponse {}

class SendCodeSuccess extends SendCodeResponse {
  final SendCodeSuccessResponse data;
    SendCodeSuccess(this.data);
}

class SendCodeFailure extends SendCodeResponse {
  final SendCodeErrorResponse error;

  SendCodeFailure(this.error);
}
