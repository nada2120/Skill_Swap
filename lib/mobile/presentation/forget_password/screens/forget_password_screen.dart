import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/forget_password/screens/verify_screen.dart';

import '../../../../shared/bloc/send_code_bloc/send_code_bloc.dart';
import '../../../../shared/data/models/send_code/send_code_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../sign/screens/sign_in_screen.dart';
import '../widgets/custom_auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  String? emailError; // validation + backend error

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final formWidth = screenWidth * 0.85; // عرض نسبي
    final borderRadius = screenWidth * 0.02; // نصف قطر نسبي
    final fontSizeError = screenWidth * 0.032; // حجم الخط نسبي

    return BlocProvider(
      create: (context) => sl<SendCodeBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
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
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: CustomAuth(
                      title: 'Forgot Password?',
                      subTitle:
                          "Enter your email and we'll send you a verification code.",
                      childWidget: Form(
                        key: formKey,
                        child: SizedBox(
                          width: formWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email Field
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Enter Email Address",
                                  filled: true,
                                  fillColor:
                                      const Color(0xFFD6D6D6).withOpacity(0.20),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                    borderSide: BorderSide(
                                      color: emailError != null
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                    borderSide: BorderSide(
                                      color: emailError != null
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                onChanged: (_) {
                                  setState(() {
                                    emailError = null;
                                  });
                                },
                              ),

                              if (emailError != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: screenHeight * 0.008),
                                  child: Text(
                                    emailError!,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: fontSizeError),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      buttonText: state is SendCodeLoading
                          ? "Verification..."
                          : "Send Verification Code",
                      onPressed: state is SendCodeLoading
                          ? null
                          : () {
                              String email = emailController.text.trim();

                              if (email.isEmpty) {
                                setState(() {
                                  emailError = "Please fill out this field.";
                                });
                                return;
                              } else if (!RegExp(
                                r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                              ).hasMatch(email)) {
                                setState(() {
                                  emailError = "Please enter a valid email.";
                                });
                                return;
                              } else {
                                setState(() {
                                  emailError = null;
                                });

                                final request = SendCodeRequest(email: email);
                                context
                                    .read<SendCodeBloc>()
                                    .add(SendVerificationCode(request));
                              }
                            },
                      bottomText: "Remember your password? ",
                      bottomActionText: "Sign In",
                      onBottomTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
