import 'package:equatable/equatable.dart';

import '../../../mobile/presentation/search/models/mentor_model.dart';

class MentorFilterState extends Equatable {
  final List<MentorModel> filteredList;

  final double minPrice;
  final double maxPrice;
  final int? selectedRate;
  final String? selectedRole;
  final String? selectedTrack;
  final String? enteredSkill;

  const MentorFilterState({
    required this.filteredList,
    this.minPrice = 20,
    this.maxPrice = 60,
    this.selectedRate,
    this.selectedRole,
    this.selectedTrack,
    this.enteredSkill,
  });

  @override
  List<Object?> get props => [
        filteredList,
        minPrice,
        maxPrice,
        selectedRate,
        selectedRole,
        selectedTrack,
        enteredSkill,
      ];

  MentorFilterState copyWith({
    List<MentorModel>? filteredList,
    double? minPrice,
    double? maxPrice,
    int? selectedRate,
    String? selectedRole,
    String? selectedTrack,
    String? enteredSkill,
  }) {
    return MentorFilterState(
      filteredList: filteredList ?? this.filteredList,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedRate: selectedRate ?? this.selectedRate,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedTrack: selectedTrack ?? this.selectedTrack,
      enteredSkill: enteredSkill ?? this.enteredSkill,
    );
  }
}
