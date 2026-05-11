import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

// الحالة الابتدائية قبل أي عملية
class LogoutInitial extends LogoutState {}

// أثناء تنفيذ logout
class LogoutLoading extends LogoutState {}

// logout نجح
class LogoutSuccessState extends LogoutState {
  final String success;

  const LogoutSuccessState({required this.success});

  @override
  List<Object?> get props => [success];
}

// logout فشل
class LogoutFailureState extends LogoutState {
  final String error;

  const LogoutFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
