import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/sign/widgets/custom_button.dart';
import 'package:skill_swap/mobile/presentation/forget_password/screens/verify_screen.dart';

import '../../../../shared/bloc/send_code_bloc/send_code_bloc.dart';
import '../../../../shared/data/models/send_code/send_code_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../sign/screens/sign_in_screen.dart';
import '../widgets/custom_auth.dart';

class ForgetPasswordDesktop extends StatefulWidget {
  const ForgetPasswordDesktop({super.key});

  @override
  State<ForgetPasswordDesktop> createState() => _ForgetPasswordDesktopState();
}

class _ForgetPasswordDesktopState extends State<ForgetPasswordDesktop> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  String? emailError;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SendCodeBloc>(),
      child: Scaffold(
        body: BlocConsumer<SendCodeBloc, SendCodeState>(
          listener: (context, state) {
            if (state is SendCodeFailureState) {
              setState(() {
                emailError = state.error.message;
              });
            }

            if (state is SendCodeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.response.message)),
              );

              Get.to(
                VerifyScreen(email: emailController.text.trim()),
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
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Enter your email and we'll send you a verification code.",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 32),

                        /// Email Field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) {
                            setState(() {
                              emailError = null;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Email Address",
                            filled: true,
                            fillColor:
                                const Color(0xFFD6D6D6).withOpacity(0.20),
                            prefixIcon: const Icon(Icons.email_outlined),
                            errorText: emailError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: emailError != null
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: emailError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        /// Button
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: state is SendCodeLoading
                                ? "Verification..."
                                : "Send Verification Code",
                            onPressed: state is SendCodeLoading
                                ? null
                                : () {
                                    String email = emailController.text.trim();

                                    if (email.isEmpty) {
                                      setState(() {
                                        emailError =
                                            "Please fill out this field.";
                                      });
                                      return;
                                    } else if (!RegExp(
                                      r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                                    ).hasMatch(email)) {
                                      setState(() {
                                        emailError =
                                            "Please enter a valid email.";
                                      });
                                      return;
                                    } else {
                                      setState(() {
                                        emailError = null;
                                      });

                                      final request =
                                          SendCodeRequest(email: email);
                                      context.read<SendCodeBloc>().add(
                                            SendVerificationCode(request),
                                          );
                                    }
                                  },
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Bottom navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Remember your password? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInDesktop(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
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
      ),
    );
  }
}
