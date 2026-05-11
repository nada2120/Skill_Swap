import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/select_skills/select_track.dart';

import '../../../../shared/bloc/activation_bloc/activation_bloc.dart';
import '../../../../shared/bloc/activation_bloc/activation_event.dart';
import '../../../../shared/bloc/activation_bloc/activation_state.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../widgets/custom_auth.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String? password;

  const EmailVerificationScreen(
      {super.key, required this.email, this.password});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isResend = false;
  int secondsRemaining = 900; // 15 minutes
  Timer? timer;

  final int numberOfFields = 4; // 4-digit code
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
    Get.to(SelectTrackScreen());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final fieldWidth = screenWidth * 0.12;
    final fieldHeight = screenHeight * 0.07;
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.05;
    final fontSize = screenWidth * 0.05;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocProvider(
        create: (context) => sl<ActivationBloc>(),
        child: BlocConsumer<ActivationBloc, ActivationState>(
          listener: (context, state) {
            if (state is ActivationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green),
              );
              if (state.message == "Account verified successfully") {
                goNextPage();
              }
            } else if (state is ActivationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding,
                        ),
                        child: CustomAuth(
                          title: 'Verify Your Email',
                          subTitle:
                              'Enter the $numberOfFields-digit code sent to ${widget.email}.',
                          childWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              numberOfFields,
                              (index) => Container(
                                width: fieldWidth,
                                height: fieldHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFFE6E7FF)),
                                ),
                                child: TextField(
                                  focusNode: focusNodes[index],
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      codeDigits[index] = value;
                                      if (index < numberOfFields - 1) {
                                        FocusScope.of(context).requestFocus(
                                            focusNodes[index + 1]);
                                      } else {
                                        FocusScope.of(context).unfocus();
                                      }
                                    } else {
                                      codeDigits[index] = "";
                                      if (index > 0) {
                                        FocusScope.of(context).requestFocus(
                                            focusNodes[index - 1]);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          buttonText: state is ActivationLoading
                              ? 'Verifying...'
                              : 'Verify',
                          onPressed: () {
                            if (codeDigits.any((element) => element.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Please enter all $numberOfFields digits"),
                                ),
                              );
                              return;
                            }

                            final code = codeDigits.join();
                            context.read<ActivationBloc>().add(VerifyActivation(
                                code: code,
                                email: widget.email,
                                password: widget.password));
                          },
                          bottomText: isResend
                              ? "Didn't receive the code? "
                              : "Resend code in ${secondsRemaining ~/ 60}:${(secondsRemaining % 60).toString().padLeft(2, '0')}",
                          bottomActionText: isResend ? 'Resend' : '',
                          onBottomTap: isResend
                              ? () {
                                  context
                                      .read<ActivationBloc>()
                                      .add(ResendActivation(widget.email));
                                  setState(() {
                                    isResend = false;
                                    secondsRemaining =
                                        900; // reset to 15 minutes
                                    codeDigits =
                                        List.filled(numberOfFields, "");
                                    for (var node in focusNodes) {
                                      node.unfocus();
                                    }
                                  });
                                  startTimer();
                                }
                              : () {},
                        ),
                      ),
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
