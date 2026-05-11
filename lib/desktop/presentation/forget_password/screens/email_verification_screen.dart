import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/select_skills/select_track.dart';
import 'package:skill_swap/desktop/presentation/sign/widgets/custom_button.dart';

import '../../../../shared/bloc/activation_bloc/activation_bloc.dart';
import '../../../../shared/bloc/activation_bloc/activation_event.dart';
import '../../../../shared/bloc/activation_bloc/activation_state.dart';
import '../../../../shared/dependency_injection/injection.dart';

class EmailVerificationDesktop extends StatefulWidget {
  final String email;
  final String? password;

  const EmailVerificationDesktop({
    super.key,
    required this.email,
    this.password,
  });

  @override
  State<EmailVerificationDesktop> createState() =>
      _EmailVerificationDesktopState();
}

class _EmailVerificationDesktopState extends State<EmailVerificationDesktop> {
  bool isResend = false;
  int secondsRemaining = 900;
  Timer? timer;

  final int numberOfFields = 4;
  late List<String> codeDigits;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    codeDigits = List.filled(numberOfFields, "");
    focusNodes = List.generate(numberOfFields, (_) => FocusNode());
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
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

  void goNextPage() {
    Get.to(const SelectTrackScreen());
  }

  String get timerText {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<ActivationBloc>(),
        child: BlocConsumer<ActivationBloc, ActivationState>(
          listener: (context, state) {
            if (state is ActivationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              if (state.message == "Account verified successfully") {
                goNextPage();
              }
            } else if (state is ActivationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ActivationLoading;

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
                        "Enter the $numberOfFields-digit code sent to ${widget.email}.",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 32),

                      /// OTP Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          numberOfFields,
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

                                  if (index < numberOfFields - 1) {
                                    FocusScope.of(context)
                                        .requestFocus(focusNodes[index + 1]);
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                } else {
                                  codeDigits[index] = "";

                                  if (index > 0) {
                                    FocusScope.of(context)
                                        .requestFocus(focusNodes[index - 1]);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: isLoading ? "Verifying..." : "Verify",
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (codeDigits.any((e) => e.isEmpty)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please enter all $numberOfFields digits",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final code = codeDigits.join();

                                  context.read<ActivationBloc>().add(
                                        VerifyActivation(
                                          code: code,
                                          email: widget.email,
                                          password: widget.password,
                                        ),
                                      );
                                },
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Resend
                      Center(
                        child: GestureDetector(
                          onTap: isResend
                              ? () {
                                  context.read<ActivationBloc>().add(
                                        ResendActivation(widget.email),
                                      );

                                  setState(() {
                                    isResend = false;
                                    secondsRemaining = 900;
                                    codeDigits =
                                        List.filled(numberOfFields, "");
                                    for (var node in focusNodes) {
                                      node.unfocus();
                                    }
                                  });

                                  startTimer();
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
