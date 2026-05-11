import 'package:equatable/equatable.dart';

abstract class JoinSessionEvent extends Equatable {
  const JoinSessionEvent();

  @override
  List<Object?> get props => [];
}

class JoinSessionRequested extends JoinSessionEvent {
  final String sessionId;

  const JoinSessionRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}
