part of 'report_bloc.dart';

@immutable
sealed class ReportState {}

final class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccessState extends ReportState {
  final ReportSuccessResponse success;

  ReportSuccessState(this.success);
}

class ReportFailureState extends ReportState {
  final ReportErrorResponse error;

  ReportFailureState(this.error);
}
