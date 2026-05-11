import 'package:equatable/equatable.dart';

import '../../../shared/data/models/join_session/join_session_response.dart';

abstract class JoinSessionState extends Equatable {
  const JoinSessionState();

  @override
  List<Object?> get props => [];
}

class JoinSessionInitial extends JoinSessionState {}

class JoinSessionLoading extends JoinSessionState {}

class JoinSessionSuccess extends JoinSessionState {
  final JoinSessionResponse response;

  const JoinSessionSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class JoinSessionFailure extends JoinSessionState {
  final String error;

  const JoinSessionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
