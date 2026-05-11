import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/sign/screens/sign_in_screen.dart';

import '../../../../shared/bloc/register_bloc/register_bloc.dart';
import '../../../../shared/bloc/register_bloc/register_event.dart';
import '../../../../shared/bloc/register_bloc/register_state.dart';
import '../../../../shared/data/models/register/register_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../forget_password/screens/email_verification_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignUpDesktop extends StatefulWidget {
  const SignUpDesktop({super.key});

  @override
  State<SignUpDesktop> createState() => _SignUpDesktopState();
}

class _SignUpDesktopState extends State<SignUpDesktop> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => sl<RegisterBloc>(),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterFailureState) {
              setState(() {
                nameError = null;
                emailError = null;
                passwordError = null;
                confirmPasswordError = null;

                final errors = state.error.validationErrors ?? [];

                if (errors.isNotEmpty) {
                  for (var err in errors) {
                    switch (err.field) {
                      case "name":
                        nameError = err.message;
                        break;
                      case "email":
                        emailError = err.message;
                        break;
                      case "password":
                        passwordError = err.message;
                        break;
                      case "confirmPassword":
                        confirmPasswordError = err.message;
                        break;
                    }
                  }
                } else {
                  emailError = state.error.message ?? "Registration failed";
                }
              });

              formKey.currentState?.validate();
            }

            if (state is RegisterSuccessState) {
              final message = state.data?.message ?? "Registered successfully";

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );

              Get.to(
                EmailVerificationDesktop(
                  email: emailController.text,
                ),
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
                          "Create Account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Join us and start your learning journey today!",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 32),

                        /// Name
                        CustomTextField(
                          controller: nameController,
                          labelText: "UserName",
                          hintText: "Enter your UserName",
                          errorText: nameError,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name is required";
                            }

                            if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9]{1,19}$')
                                .hasMatch(value)) {
                              return "Only letters and numbers, no spaces, and must not start with a number";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

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
                          hintText: "Create a password",
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
                          hintText: "Confirm your password",
                          obscureText: true,
                          errorText: confirmPasswordError,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm password is required";
                            }
                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        /// Button
                        CustomButton(
                          text: state is RegisterLoading
                              ? "Registering..."
                              : "Sign Up",
                          onPressed: state is RegisterLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<RegisterBloc>().add(
                                          RegisterSubmit(
                                            RegisterRequest(
                                              name: nameController.text,
                                              email: emailController.text,
                                              password: passwordController.text,
                                              confirmPassword:
                                                  confirmPasswordController
                                                      .text,
                                            ),
                                          ),
                                        );
                                  }
                                },
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                            ),
                            GestureDetector(
                              onTap: () => Get.to(SignInDesktop()),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
