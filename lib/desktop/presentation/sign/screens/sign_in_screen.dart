import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/sign/screens/sign_up_screen.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/login_bloc/login_bloc.dart';
import '../../../../shared/bloc/login_bloc/login_event.dart';
import '../../../../shared/bloc/login_bloc/login_state.dart';
import '../../../../shared/data/models/login/login_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/helper/local_storage.dart';
import '../../common/desktop_scaffold.dart';
import '../../common/desktop_screen_manager.dart';
import '../../forget_password/screens/forget_password_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignInDesktop extends StatefulWidget {
  const SignInDesktop({super.key});

  @override
  State<SignInDesktop> createState() => _SignInDesktopState();
}

class _SignInDesktopState extends State<SignInDesktop> {
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
    return Scaffold(
        body: BlocProvider(
      create: (_) => sl<LoginBloc>(),
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
            await LocalStorage.saveToken(state.data.accessToken);
            await LocalStorage.saveRefreshToken(state.data.refreshToken);
            await LocalStorage.saveUserId(state.data.id);

            Get.offAll(
              DesktopScaffold(
                body: DesktopScreenManager(key: desktopKey),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.data.message)),
            );
          }
        },
        builder: (context, state) {
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
                      color: Theme.of(context).dividerColor, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
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
                      /// Title
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Sign in to continue your learning journey",
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 32),

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

                      const SizedBox(height: 32),

                      /// Button
                      CustomButton(
                        text:
                            state is LoginLoading ? "Logging in..." : "Sign In",
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

                      const SizedBox(height: 20),

                      /// Forget Password
                      Center(
                        child: TextButton(
                          onPressed: () => Get.to(ForgetPasswordDesktop()),
                          child: const Text("Forget Password?"),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account? "),
                          GestureDetector(
                            onTap: () => Get.to(SignUpDesktop()),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
