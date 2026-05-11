import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../bloc/report_bloc/report_bloc.dart';
import '../data/models/report_user/report_request.dart';

class SessionEndDialog extends StatefulWidget {
  final num price;
  final String bookingCode;
  final bool isStudent;

  const SessionEndDialog({
    super.key,
    required this.price,
    required this.bookingCode,
    required this.isStudent,
  });

  @override
  State<SessionEndDialog> createState() => _SessionEndDialogState();
}

class _SessionEndDialogState extends State<SessionEndDialog> {
  final TextEditingController controller = TextEditingController();

  bool isReportMode = false;

  String? reportedUserName;
  String? reportedUserId;
  bool isLoadingUser = false;

  String _getMessage() {
    if (widget.isStudent && widget.price == 0) {
      return "Don't worry, your time won't be deducted.";
    }

    if (widget.isStudent && widget.price > 0) {
      return "Don't worry, your money will be returned to you.";
    }

    return "";
  }

  Future<void> _openReport() async {
    setState(() {
      isLoadingUser = true;
    });

    final user = await context
        .read<GetBookingsCubit>()
        .getNotJoinedUserFromAccepted(widget.bookingCode);

    setState(() {
      isLoadingUser = false;
    });

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No user found")),
      );
      return;
    }

    setState(() {
      reportedUserName = user.name;
      reportedUserId = user.id;
      isReportMode = true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowDialog =
        widget.isStudent && (widget.price == 0 || widget.price > 0);

    if (!shouldShowDialog) {
      return const SizedBox.shrink();
    }

    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccessState) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.success.message)),
          );
        }

        if (state is ReportFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.message)),
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          isReportMode ? "Report ${reportedUserName ?? ""}" : "Session Ended",
        ),
        content: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoadingUser
              ? const SizedBox(
                  height: 60,
                  child: Center(child: CircularProgressIndicator()),
                )
              : isReportMode
                  ? Column(
                      key: const ValueKey("report"),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Why are you reporting $reportedUserName?",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controller,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Write your report reason...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      _getMessage(),
                      key: const ValueKey("message"),
                    ),
        ),
        actions: isReportMode
            ? [
                TextButton(
                  onPressed: () {
                    setState(() => isReportMode = false);
                  },
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;

                    final request = ReportRequest(
                      reason: controller.text.trim(),
                      reportedUser: reportedUserId!,
                    );

                    context.read<ReportBloc>().add(ConfirmSubmit(request));
                  },
                  child: const Text("Send"),
                ),
              ]
            : [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
                TextButton(
                  onPressed: _openReport,
                  child: const Text("Report"),
                ),
              ],
      ),
    );
  }
}
