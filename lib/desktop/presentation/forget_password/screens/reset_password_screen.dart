import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/reset_password_bloc/reset_password_bloc.dart';
import '../../../../shared/data/models/reset_password/reset_password_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../sign/screens/sign_in_screen.dart';
import '../../sign/widgets/custom_button.dart';
import '../../sign/widgets/custom_text_field.dart';

class ResetPasswordDesktop extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordDesktop({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordDesktop> createState() => _ResetPasswordDesktopState();
}

class _ResetPasswordDesktopState extends State<ResetPasswordDesktop> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordBloc>(),
      child: Scaffold(
        body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error.message)),
              );
            }

            if (state is ResetPasswordSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.data.message)),
              );

              Get.offAll(() => const SignInDesktop());
            }
          },
          builder: (context, state) {
            final isLoading = state is ResetPasswordLoading;

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
                          "Create New Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Enter your new password to continue",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 32),

                        /// New Password
                        CustomTextField(
                          controller: newPasswordController,
                          labelText: "New Password",
                          hintText: "Enter new password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!RegExp(
                              r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                            ).hasMatch(value)) {
                              return "Password must be 8+ chars, upper, lower & number";
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
                            text: isLoading ? "Updating..." : "Confirm",
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      final request = ResetPasswordRequest(
                                        email: widget.email,
                                        forgetCode: widget.code,
                                        password: newPasswordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                      );

                                      context
                                          .read<ResetPasswordBloc>()
                                          .add(ConfirmSubmit(request));
                                    }
                                  },
                          ),
                        ),

                        const SizedBox(height: 20),
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
