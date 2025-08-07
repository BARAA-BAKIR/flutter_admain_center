part of 'center_add_student_bloc.dart';

enum CenterAddStudentStatus { initial, loading, success, failure }

class CenterAddStudentState extends Equatable {
  final CenterAddStudentStatus status;
  final int currentStep;
  final String gender;
  final String socialStatus;
  final List<LevelModel> levels;
  final bool isLoadingLevels;
  final int? selectedLevelId;
  final List<Halaqa> halaqas;
  final bool isLoadingHalaqas;
  final int? selectedHalaqaId;
  final String? errorMessage;

  const CenterAddStudentState({
    this.status = CenterAddStudentStatus.initial,
    this.currentStep = 0,
    this.gender = 'ذكر',
    this.socialStatus = 'اعزب',
    this.levels = const [],
    this.isLoadingLevels = false,
    this.selectedLevelId,
    this.halaqas = const [],
    this.isLoadingHalaqas = false,
    this.selectedHalaqaId,
    this.errorMessage,
  });

  CenterAddStudentState copyWith({
    CenterAddStudentStatus? status,
    int? currentStep,
    String? gender,
    String? socialStatus,
    List<LevelModel>? levels,
    bool? isLoadingLevels,
    int? selectedLevelId,
    List<Halaqa>? halaqas,
    bool? isLoadingHalaqas,
    int? selectedHalaqaId,
    String? errorMessage,
  }) {
    return CenterAddStudentState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      gender: gender ?? this.gender,
      socialStatus: socialStatus ?? this.socialStatus,
      levels: levels ?? this.levels,
      isLoadingLevels: isLoadingLevels ?? this.isLoadingLevels,
      selectedLevelId: selectedLevelId ?? this.selectedLevelId,
      halaqas: halaqas ?? this.halaqas,
      isLoadingHalaqas: isLoadingHalaqas ?? this.isLoadingHalaqas,
      selectedHalaqaId: selectedHalaqaId ?? this.selectedHalaqaId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentStep, gender, socialStatus, levels, isLoadingLevels, selectedLevelId, halaqas, isLoadingHalaqas, selectedHalaqaId, errorMessage];
}
