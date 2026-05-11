import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../bloc/report_bloc/report_bloc.dart';
import '../data/models/report_user/report_request.dart';
import '../dependency_injection/injection.dart';

class ReportDialog extends StatefulWidget {
  final String userId;
  final String userName;

  const ReportDialog({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccessState) {
          Navigator.pop(context);
          Get.snackbar('Success', state.success.message);
        } else if (state is ReportFailureState) {
          Get.snackbar('Error', state.error.message);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Why are you reporting ${widget.userName}?",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write your reason here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BlocBuilder<ReportBloc, ReportState>(
                      builder: (context, state) {
                        final isLoading = state is ReportLoading;

                        return ElevatedButton(
                          onPressed:
                              (isLoading || controller.text.trim().isEmpty)
                                  ? null
                                  : () {
                                      final request = ReportRequest(
                                        reason: controller.text.trim(),
                                        reportedUser: widget.userId,
                                      );

                                      context
                                          .read<ReportBloc>()
                                          .add(ConfirmSubmit(request));
                                    },
                          child: isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Send"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showReportDialog({
  required BuildContext context,
  required String userId,
  required String userName,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return BlocProvider(
        create: (_) => sl<ReportBloc>(),
        child: ReportDialog(
          userId: userId,
          userName: userName,
        ),
      );
    },
  );
}
