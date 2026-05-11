import 'package:equatable/equatable.dart';

import '../../data/models/track/skills_response.dart';

abstract class SkillsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SkillsInitial extends SkillsState {}

class SkillsLoading extends SkillsState {}

class SkillsLoaded extends SkillsState {
  final SkillsResponse response;

  SkillsLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class SkillsError extends SkillsState {
  final String error;

  SkillsError(this.error);

  @override
  List<Object?> get props => [error];
}
