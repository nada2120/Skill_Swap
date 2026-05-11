part of 'report_bloc.dart';

@immutable
sealed class ReportEvent {}

class ConfirmSubmit extends ReportEvent {
  final ReportRequest request;

  ConfirmSubmit(this.request);
}
