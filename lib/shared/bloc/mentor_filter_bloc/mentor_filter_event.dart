import 'package:equatable/equatable.dart';

abstract class MentorFilterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplyFiltersEvent extends MentorFilterEvent {
  final double? minPrice;
  final double? maxPrice;
  final double? minRate;
  final String? role;
  final String? skill;
  final String? track;

  ApplyFiltersEvent(
      {this.minPrice,
      this.maxPrice,
      this.minRate,
      this.role,
      this.skill,
      this.track});
}

class ResetFiltersEvent extends MentorFilterEvent {}

class SearchMentorEvent extends MentorFilterEvent {
  final String query;

  SearchMentorEvent(this.query);
}

enum SortType { priceLowToHigh, priceHighToLow, nameAZ, nameZA, rateHigh }

class SortMentorEvent extends MentorFilterEvent {
  final SortType type;

  SortMentorEvent(this.type);
}
