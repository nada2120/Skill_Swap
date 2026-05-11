import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/web_services/skills/skills_api_services.dart';
import 'skills_state.dart';

class SkillsCubit extends Cubit<SkillsState> {
  final SkillsApiService api;

  SkillsCubit(this.api) : super(SkillsInitial());

  Future<void> fetchSkills(String trackId) async {
    emit(SkillsLoading());

    try {
      final result = await api.getSkills(trackId);
      emit(SkillsLoaded(result));
    } catch (e) {
      emit(SkillsError(e.toString()));
    }
  }
}
