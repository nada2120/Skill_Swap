import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../mobile/presentation/search/models/mentor_model.dart';
import 'mentor_filter_event.dart';
import 'mentor_filter_state.dart';

class MentorFilterBloc extends Bloc<MentorFilterEvent, MentorFilterState> {
  final List<MentorModel> allMentors;

  MentorFilterBloc(this.allMentors)
      : super(MentorFilterState(filteredList: allMentors)) {
    on<ApplyFiltersEvent>((event, emit) {
      List<MentorModel> data = allMentors;

      // Price filter
      data = data
          .where(
              (m) => m.price >= event.minPrice! && m.price <= event.maxPrice!)
          .toList();

      // Rate
      if (event.minRate != null) {
        data = data.where((m) => m.rate >= event.minRate!).toList();
      }

      // Status
      if (event.role != null) {
        data = data.where((m) => m.status == event.role).toList();
      }

      // Track
      if (event.track != null) {
        data = data.where((m) => m.track == event.track).toList();
      }

      // Skill
      if (event.skill != null && event.skill!.isNotEmpty) {
        data = data
            .where((m) => m.skills.any(
                (s) => s.toLowerCase().contains(event.skill!.toLowerCase())))
            .toList();
      }

      emit(state.copyWith(
        filteredList: data,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        selectedRate: event.minRate?.toInt(),
        selectedRole: event.role,
        selectedTrack: event.track,
        enteredSkill: event.skill,
      ));
    });

    on<SearchMentorEvent>((event, emit) {
      emit(state.copyWith(filteredList: []));
    });

    on<ResetFiltersEvent>((event, emit) {
      emit(state.copyWith(
        filteredList: allMentors,
        minPrice: 20,
        maxPrice: 60,
        selectedRate: null,
        selectedRole: null,
        selectedTrack: null,
        enteredSkill: null,
      ));
    });
    on<SortMentorEvent>((event, emit) {
      final sorted = List<MentorModel>.from(state.filteredList);

      switch (event.type) {
        case SortType.priceLowToHigh:
          sorted.sort((a, b) => a.price.compareTo(b.price));
          break;

        case SortType.priceHighToLow:
          sorted.sort((a, b) => b.price.compareTo(a.price));
          break;

        case SortType.nameAZ:
          sorted.sort((a, b) => a.name.compareTo(b.name));
          break;

        case SortType.nameZA:
          sorted.sort((a, b) => b.name.compareTo(a.name));
          break;

        case SortType.rateHigh:
          sorted.sort((a, b) => b.rate.compareTo(a.rate));
          break;
      }

      emit(state.copyWith(filteredList: sorted));
    });
  }
}
