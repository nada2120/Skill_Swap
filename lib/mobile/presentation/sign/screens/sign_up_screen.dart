import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/sign/screens/sign_in_screen.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/register_bloc/register_bloc.dart';
import '../../../../shared/bloc/register_bloc/register_event.dart';
import '../../../../shared/bloc/register_bloc/register_state.dart';
import '../../../../shared/data/models/register/register_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/helper/local_storage.dart';
import '../../forget_password/screens/email_verification_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  late final RegisterBloc registerBloc;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();
    registerBloc = sl<RegisterBloc>();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: registerBloc,
      child: BaseScreen(
        title: "Sign Up",
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) async {
            if (state is RegisterFailureState) {
              setState(() {
                nameError = null;
                emailError = null;
                passwordError = null;
                confirmPasswordError = null;

                final errors = state.error.validationErrors;

                if (errors != null && errors.isNotEmpty) {
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
                  emailError = state.error.message;
                }
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) formKey.currentState?.validate();
              });
            }

            if (state is RegisterSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.data.message)),
              );
              await LocalStorage.saveEmail(
                emailController.text,
              );
              Get.to(
                EmailVerificationScreen(
                  email: emailController.text,
                  password: passwordController.text,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Join us and start your learning journey today!",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// NAME
                      CustomTextField(
                        controller: nameController,
                        labelText: "Username",
                        hintText: "Enter your username",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name is required";
                          }

                          final nameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$');

                          if (!nameRegex.hasMatch(value)) {
                            return "Must start with a letter and contain only letters and numbers (no space)";
                          }

                          if (value.length < 2 || value.length > 20) {
                            return "Name must be between 2 and 20 characters";
                          }

                          return nameError;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// EMAIL
                      CustomTextField(
                        controller: emailController,
                        labelText: "Email",
                        hintText: "Enter your email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          if (!RegExp(
                            r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                          ).hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return emailError;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// PASSWORD
                      CustomTextField(
                        controller: passwordController,
                        labelText: "Password",
                        hintText: "Create a password",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (!RegExp(
                            r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                          ).hasMatch(value)) {
                            return "Password must contain uppercase, lowercase, number";
                          }
                          return passwordError;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// CONFIRM PASSWORD
                      CustomTextField(
                        controller: confirmPasswordController,
                        labelText: "Confirm Password",
                        hintText: "Confirm your password",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Confirm password is required";
                          }
                          if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return confirmPasswordError;
                        },
                      ),
                      const SizedBox(height: 32),

                      CustomButton(
                        text: state is RegisterLoading
                            ? "Registering..."
                            : "Sign Up",
                        onPressed: state is RegisterLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  registerBloc.add(
                                    RegisterSubmit(
                                      RegisterRequest(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
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
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(SignInScreen()),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
