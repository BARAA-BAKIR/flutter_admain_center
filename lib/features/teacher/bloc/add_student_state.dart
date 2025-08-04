part of 'add_student_bloc.dart';

class AddStudentState {
  final int currentStep;
  final bool isSaving;
  final String? error;
  final bool saveSuccess;
  final List<LevelModel> levels;
  final bool isLoadingLevels;
  final int? selectedLevelId;
  final String gender;
 final String social_status;
  const AddStudentState({
    this.currentStep = 0,
    this.isSaving = false,
    this.error,
    this.saveSuccess = false,
    this.social_status = 'اعزب', // قيمة افتراضية
    this.gender = 'ذكر', // قيمة افتراضية
    this.levels = const [],
    this.isLoadingLevels = false,
    this.selectedLevelId, // معرف المستوى المحدد
  });

  AddStudentState copyWith({
    int? currentStep,
    bool? isSaving,
    String? error,
    bool? saveSuccess,
    String? gender,
    String? social_status,
    List<LevelModel>? levels,
    bool? isLoadingLevels,
    int? selectedLevelId,
  }) {
    return AddStudentState(
      currentStep: currentStep ?? this.currentStep,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      social_status: social_status ?? this.social_status,
      gender: gender ?? this.gender,
      levels: levels ?? this.levels,
      isLoadingLevels: isLoadingLevels ?? this.isLoadingLevels,
      selectedLevelId: selectedLevelId ?? this.selectedLevelId,
    );
  }
}
