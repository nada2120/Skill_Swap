import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/reset_password_bloc/reset_password_bloc.dart';
import '../../../../shared/data/models/reset_password/reset_password_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../sign/screens/sign_in_screen.dart';
import '../../sign/widgets/custom_appbar.dart';
import '../../sign/widgets/custom_button.dart';
import '../../sign/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final fieldSpacing = screenHeight * 0.02;
    final titleFontSize = screenWidth * 0.06;
    final subTitleFontSize = screenWidth * 0.04;
    final buttonHeight = screenHeight * 0.07;

    return BlocProvider(
      create: (context) => sl<ResetPasswordBloc>(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        appBar: const CustomAppBar(title: "Reset Password"),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),

                Text(
                  "Create New Password",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge!
                        .color,
                  ),
                ),

                SizedBox(height: fieldSpacing / 2),

                Text(
                  "Enter your new password to continue",
                  style: TextStyle(
                    fontSize: subTitleFontSize,
                    color: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium!
                        .color,
                  ),
                ),

                SizedBox(height: fieldSpacing),

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

                SizedBox(height: fieldSpacing),

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

                SizedBox(height: fieldSpacing * 1.5),

                /// Button
                BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
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

                      Get.offAll(() => const SignInScreen());
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is ResetPasswordLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
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
                    );
                  },
                ),

                SizedBox(height: fieldSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}