import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/sign/screens/sign_in_screen.dart';

import '../../../../desktop/presentation/sign/widgets/custom_text_field.dart';
import '../../../../shared/bloc/change_password_bloc/change_password_bloc.dart';
import '../../../../shared/data/models/change_password/change_password_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../forget_password/screens/forget_password_screen.dart';
import '../../sign/widgets/custom_button.dart';

class ChangePasswordDesktop extends StatefulWidget {
  const ChangePasswordDesktop({super.key});

  @override
  State<ChangePasswordDesktop> createState() => _ChangePasswordDesktopState();
}

class _ChangePasswordDesktopState extends State<ChangePasswordDesktop> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? oldPasswordError;
  String? passwordError;
  String? confirmPasswordError;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangePasswordBloc>(),
      child: Scaffold(
        body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordFailureState) {
              Get.snackbar('Error', state.error.message);

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
                  passwordError = state.error.message;
                }
              });

              formKey.currentState?.validate();
            }

            if (state is ChangePasswordSuccessState) {
              Get.snackbar('Success', state.success.message);
              Get.to(SignInDesktop());
            }
          },
          builder: (context, state) {
            final isLoading = state is ChangePasswordLoading;

            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 450,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.5),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black12,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Update your password to keep your account secure",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 32),

                        /// Old Password
                        CustomTextField(
                          controller: oldPasswordController,
                          labelText: "Old Password",
                          hintText: "Enter old password",
                          obscureText: true,
                          errorText: oldPasswordError,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Old password is required";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// New Password
                        CustomTextField(
                          controller: newPasswordController,
                          labelText: "New Password",
                          hintText: "Enter new password",
                          obscureText: true,
                          errorText: passwordError,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!RegExp(
                              r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                            ).hasMatch(value)) {
                              return "Password must contain uppercase, lowercase and number";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// Confirm Password
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: "Confirm Password",
                          hintText: "Re-enter password",
                          obscureText: true,
                          errorText: confirmPasswordError,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm password is required";
                            }
                            if (value != newPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        /// Button
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: isLoading ? "Changing..." : "Change Password",
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<ChangePasswordBloc>().add(
                                            ConfirmSubmit(
                                              ChangePasswordRequest(
                                                oldPassword:
                                                    oldPasswordController.text
                                                        .trim(),
                                                newPassword:
                                                    newPasswordController.text
                                                        .trim(),
                                                confirmPassword:
                                                    confirmPasswordController
                                                        .text
                                                        .trim(),
                                              ),
                                            ),
                                          );
                                    }
                                  },
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: GestureDetector(
                            onTap: () => Get.to(ForgetPasswordDesktop()),
                            child: const Text(
                              "Forget Old Password?",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
