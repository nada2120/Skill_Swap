import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/quiz/quiz_controller.dart';

class QuizDesktop extends StatefulWidget {
  final bool fromAddSkill;

  const QuizDesktop({super.key, this.fromAddSkill = false});

  @override
  State<QuizDesktop> createState() => _QuizDesktopState();
}

class _QuizDesktopState extends State<QuizDesktop> {
  final QuizController controller = Get.find<QuizController>();

  RxInt remainingSeconds = QuizController.totalTimeInSeconds.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        controller.goToResult();
      }
    });
  }

  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(
        2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.questions.isEmpty) {
        return const Scaffold(
          body: Center(child: Text("Failed to load quiz")),
        );
      }

      final q = controller.questions[controller.index.value];

      return Scaffold(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme
              .of(context)
              .scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Quiz",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor
                      .withValues(alpha: 0.5),
                  border: Border.all(
                    color: Theme
                        .of(context)
                        .dividerColor,
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

                    /// TIMER + PROGRESS HEADER
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(width: 8),
                        Obx(() => Text(formattedTime)),

                        const Spacer(),

                        Text(
                          "${controller.index.value + 1}/${controller.questions
                              .length}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    LinearProgressIndicator(
                      value: (controller.index.value + 1) /
                          controller.questions.length,
                      minHeight: 8,
                    ),

                    const SizedBox(height: 24),

                    /// QUESTION CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme
                              .of(context)
                              .dividerColor,
                        ),
                      ),
                      child: Text(
                        q.question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// OPTIONS
                    ...List.generate(q.options.length, (i) {
                      final isSelected =
                          controller.selectedOption.value == i;

                      return GestureDetector(
                        onTap: () =>
                        controller.selectedOption.value = i,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Theme
                                  .of(context)
                                  .dividerColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(q.options[i])),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.index.value == 0
                                ? null
                                : controller.previousQuestion,
                            child: const Text("Previous"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.nextQuestion,
                            child: Obx(
                                  () =>
                                  Text(
                                    controller.index.value ==
                                        controller.questions.length - 1
                                        ? "Finish"
                                        : "Next",
                                  ),
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
        ),
      );
    });
  }
}
