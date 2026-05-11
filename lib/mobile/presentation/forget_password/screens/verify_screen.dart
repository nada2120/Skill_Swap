import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/forget_password/screens/reset_password_screen.dart';

import '../../../../shared/bloc/send_code_bloc/send_code_bloc.dart';
import '../../../../shared/bloc/verify_code_bloc/verify_code_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../widgets/custom_auth.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
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
    timer = Timer.periodic(Duration(seconds: 1), (t) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<VerifyCodeBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SendCodeBloc>(),
        )
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              Get.to(ResetPasswordDesktop(
                email: widget.email,
                code: code,
              ));
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
                      child: CustomAuth(
                        title: 'Verify Your Email',
                        subTitle:
                            'Enter the 6-digit code sent to ${widget.email}.',
                        childWidget: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                6,
                                (index) => Container(
                                  width: 45,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                  ),
                                  child: TextField(
                                    focusNode: focusNodes[index],
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: isDark
                                            ? Colors.white
                                            : AppPalette.primary),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        codeDigits[index] = value;

                                        if (index < 5) {
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
                            if (codeError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  codeError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                          ],
                        ),
                        buttonText: state is VerifyCodeLoading
                            ? 'Verification'
                            : 'Verify',
                        onPressed: state is VerifyCodeLoading
                            ? null
                            : () {
                                if (codeDigits.any((digit) => digit.isEmpty)) {
                                  setState(() {
                                    codeError = "Please enter all 6 digits";
                                  });
                                  return;
                                }

                                final code = codeDigits.join();

                                context.read<VerifyCodeBloc>().add(
                                      SubmitVerify(
                                        widget.email,
                                        code,
                                      ),
                                    );
                              },
                        bottomText: isResend
                            ? "Didn't receive the code? "
                            : "Resend code in $timerText",
                        bottomActionText: isResend ? 'Resend' : '',
                        onBottomTap: isResend
                            ? () {
                                setState(() {
                                  isResend = false;
                                  secondsRemaining = 900; // 15 دقيقة
                                });
                                startTimer();
                                context
                                    .read<SendCodeBloc>()
                                    .add(ResendCode(widget.email));
                              }
                            : () {},
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
