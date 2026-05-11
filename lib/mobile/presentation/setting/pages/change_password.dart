import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/change_password_bloc/change_password_bloc.dart';
import '../../../../shared/common_ui/base_screen.dart';
import '../../../../shared/data/models/change_password/change_password_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../forget_password/screens/forget_password_screen.dart';
import '../../sign/screens/sign_in_screen.dart';
import '../../sign/widgets/custom_button.dart';
import '../../sign/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? oldPasswordError;
  String? passwordError;
  String? confirmPasswordError;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? oldPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Old password is required";
    }
    return oldPasswordError;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (!RegExp(
      r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
    ).hasMatch(value)) {
      return "Password must contain uppercase, lowercase and number";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    double subtitleFontSize = screenWidth >= 800 ? 18 : 16;
    double paddingAll = screenWidth >= 800 ? 24 : 16;

    return BlocProvider(
      create: (_) => sl<ChangePasswordBloc>(),
      child: BaseScreen(
        title: "Change Password",
        child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            /// FAILURE
            if (state is ChangePasswordFailureState) {
              //  Get.snackbar('Error', state.error.message);

              setState(() {
                oldPasswordError = null;
                passwordError = null;
                confirmPasswordError = null;

                final errors = state.error.validationErrors;

                if (errors != null && errors.isNotEmpty) {
                  for (var err in errors) {
                    switch (err.field) {
                      case "oldPassword":
                        oldPasswordError = err.message;
                        break;

                      case "newPassword":
                        passwordError = err.message;
                        break;

                      case "confirmPassword":
                        confirmPasswordError = err.message;
                        break;
                    }
                  }
                } else {
                  oldPasswordError = state.error.message;
                }
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  formKey.currentState?.validate();
                }
              });
            }

            /// SUCCESS
            if (state is ChangePasswordSuccessState) {
              Get.snackbar('Success', state.success.message);
              Get.offAll(() => SignInScreen());
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(paddingAll),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// OLD PASSWORD
                      CustomTextField(
                          controller: oldPasswordController,
                          labelText: "Old Password",
                          hintText: "Enter old password",
                          obscureText: true,
                          validator: oldPasswordValidator
                      ),

                      const SizedBox(height: 16),

                      /// NEW PASSWORD
                      CustomTextField(
                        controller: newPasswordController,
                        labelText: "New Password",
                        hintText: "Enter new password",
                        obscureText: true,
                        validator: (value) {
                          final localError = passwordValidator(value);
                          if (localError != null) return localError;
                          return passwordError;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// CONFIRM PASSWORD
                      CustomTextField(
                        controller: confirmPasswordController,
                        labelText: "Confirm Password",
                        hintText: "Re-enter password",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Confirm password is required";
                          }

                          if (value != newPasswordController.text) {
                            return "Passwords do not match";
                          }

                          return confirmPasswordError;
                        },
                      ),

                      const SizedBox(height: 24),

                      /// BUTTON
                      CustomButton(
                        text: state is ChangePasswordLoading
                            ? "Changing..."
                            : "Change Password",
                        onPressed: state is ChangePasswordLoading
                            ? null
                            : () {
                          setState(() {
                            oldPasswordError = null;
                            passwordError = null;
                            confirmPasswordError = null;
                          });

                          if (formKey.currentState!.validate()) {
                            context.read<ChangePasswordBloc>().add(
                              ConfirmSubmit(
                                ChangePasswordRequest(
                                  oldPassword: oldPasswordController
                                      .text
                                      .trim(),
                                  newPassword: newPasswordController
                                      .text
                                      .trim(),
                                  confirmPassword:
                                  confirmPasswordController.text
                                      .trim(),
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      /// FORGET PASSWORD
                      Center(
                        child: TextButton(
                          onPressed: () => Get.to(() => ForgetPassword()),
                          child: Text(
                            "Forget Old Password?",
                            style: TextStyle(fontSize: subtitleFontSize),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
