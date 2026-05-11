import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/sign/screens/sign_up_screen.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/login_bloc/login_bloc.dart';
import '../../../../shared/bloc/login_bloc/login_event.dart';
import '../../../../shared/bloc/login_bloc/login_state.dart';
import '../../../../shared/common_ui/screen_manager/screen_manager.dart';
import '../../../../shared/data/models/login/login_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../forget_password/screens/forget_password_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  void _clearErrors() {
    emailError = null;
    passwordError = null;
  }

  void _handleServerError(LoginFailureState state) {
    _clearErrors();

    if (state.error.message == "Invalid Login Data") {
      passwordError = "Password is not correct";
    } else if (state.error.message == "Not Register Account") {
      emailError = "Email is not registered";
    }

    final validationErrors = state.error.validationErrors;
    if (validationErrors != null) {
      for (var err in validationErrors) {
        if (err.field == "email") emailError = err.message;
        if (err.field == "password") passwordError = err.message;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = 22;
    double subtitleFontSize = 16;
    double paddingAll = 16;
    double spacing = 32;

    if (screenWidth >= 800) {
      titleFontSize = 28;
      subtitleFontSize = 18;
      paddingAll = 24;
      spacing = 40;
    }

    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: BaseScreen(
        title: "Sign In",
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginFailureState) {
              _handleServerError(state);
              setState(() {});

              if (emailError == null && passwordError == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else if (state is LoginSuccessState) {
              // await LocalStorage.saveToken(state.data.accessToken);
              //  await LocalStorage.saveRefreshToken(state.data.refreshToken);
              //await LocalStorage.saveUserId(state.data.id);
              context.read<MyProfileCubit>().fetchMyProfile();
              Get.offAll(ScreenManager(initialIndex: 0));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.data.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(paddingAll),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: spacing),
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue your learning journey",
                      style: TextStyle(fontSize: subtitleFontSize),
                    ),
                    SizedBox(height: spacing),

                    /// Email
                    CustomTextField(
                      controller: emailController,
                      labelText: "Email",
                      hintText: "Enter your email",
                      errorText: emailError,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(
                          r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                        ).hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    /// Password
                    CustomTextField(
                      controller: passwordController,
                      labelText: "Password",
                      hintText: "Enter your password",
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

                    SizedBox(height: spacing),

                    /// Button
                    CustomButton(
                      text: state is LoginLoading ? "Logging in..." : "Sign In",
                      onPressed: state is LoginLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(
                                      LoginSubmit(
                                        LoginRequest(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ),
                                      ),
                                    );
                              }
                            },
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: TextButton(
                        onPressed: () => Get.to(ForgetPassword()),
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(fontSize: subtitleFontSize),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: TextStyle(fontSize: subtitleFontSize),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(SignUpScreen()),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
