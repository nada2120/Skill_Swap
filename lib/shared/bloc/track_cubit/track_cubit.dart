import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/track/track_model.dart';
import '../../domain/repositories/auth_repository.dart';

// States
abstract class TracksState {}

class TracksInitial extends TracksState {}

class TracksLoading extends TracksState {}

class TracksLoaded extends TracksState {
  final List<TrackModel> tracks;

  TracksLoaded(this.tracks);
}

class TracksError extends TracksState {
  final String message;

  TracksError(this.message);
}

// Cubit
class TracksCubit extends Cubit<TracksState> {
  final AuthRepository repo;

  TracksCubit(this.repo) : super(TracksInitial());

  Future<void> fetchTracks() async {
    emit(TracksLoading());
    try {
      final tracks = await repo.fetchTracks();
      emit(TracksLoaded(tracks));
    } catch (e) {
      emit(TracksError(e.toString()));
    }
  }
}
