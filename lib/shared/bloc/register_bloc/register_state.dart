import '../../data/models/register/register_success_response.dart';
import '../../data/models/register/register_error_response.dart';

sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final RegisterSuccessResponse data;
  RegisterSuccessState(this.data);
}

class RegisterFailureState extends RegisterState {
  final RegisterErrorResponse error;
  RegisterFailureState(this.error);
}
