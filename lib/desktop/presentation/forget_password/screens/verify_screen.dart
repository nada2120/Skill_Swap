import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/forget_password/screens/reset_password_screen.dart';
import 'package:skill_swap/desktop/presentation/sign/widgets/custom_button.dart';

import '../../../../shared/bloc/send_code_bloc/send_code_bloc.dart';
import '../../../../shared/bloc/verify_code_bloc/verify_code_bloc.dart';
import '../../../../shared/dependency_injection/injection.dart';

class VerifyDesktop extends StatefulWidget {
  final String email;

  const VerifyDesktop({super.key, required this.email});

  @override
  State<VerifyDesktop> createState() => _VerifyDesktopState();
}

class _VerifyDesktopState extends State<VerifyDesktop> {
  bool isResend = false;
  int secondsRemaining = 900;
  late Timer timer;
  String? codeError;

  List<String> codeDigits = List.filled(6, "");
  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          isResend = true;
          t.cancel();
        }
      });
    });
  }

  String get timerText {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<VerifyCodeBloc>()),
        BlocProvider(create: (_) => sl<SendCodeBloc>()),
      ],
      child: Scaffold(
        body: BlocConsumer<VerifyCodeBloc, VerifyCodeState>(
          listener: (context, state) {
            if (state is VerifyCodeFailureState) {
              setState(() {
                codeError = state.error.message;
              });
            } else if (state is VerifyCodeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.response.message)),
              );

              final code = codeDigits.join();

              Get.to(
                ResetPasswordDesktop(
                  email: widget.email,
                  code: code,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is VerifyCodeLoading;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Verify Your Email",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Enter the 6-digit code sent to ${widget.email}.",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 32),

                      /// OTP Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => Container(
                            width: 45,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: TextField(
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  codeDigits[index] = value;

                                  if (index < 5) {
                                    FocusScope.of(context).requestFocus(
                                      focusNodes[index + 1],
                                    );
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                } else {
                                  codeDigits[index] = "";

                                  if (index > 0) {
                                    FocusScope.of(context).requestFocus(
                                      focusNodes[index - 1],
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      if (codeError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          codeError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],

                      const SizedBox(height: 32),

                      /// Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: isLoading ? "Verifying..." : "Verify",
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (codeDigits.any((d) => d.isEmpty)) {
                                    setState(() {
                                      codeError = "Please enter all 6 digits";
                                    });
                                    return;
                                  }

                                  final code = codeDigits.join();

                                  context.read<VerifyCodeBloc>().add(
                                        SubmitVerify(widget.email, code),
                                      );
                                },
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Bottom
                      Center(
                        child: GestureDetector(
                          onTap: isResend
                              ? () {
                                  setState(() {
                                    isResend = false;
                                    secondsRemaining = 900;
                                  });
                                  startTimer();
                                  context
                                      .read<SendCodeBloc>()
                                      .add(ResendCode(widget.email));
                                }
                              : null,
                          child: Text(
                            isResend
                                ? "Didn't receive the code? Resend"
                                : "Resend code in $timerText",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isResend ? Colors.blue : Colors.grey,
                            ),
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
