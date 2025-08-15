part of 'add_halaqa_bloc.dart';

enum AddHalaqaStatus { initial, loading, success, failure, submitting }

class AddHalaqaState extends Equatable {
  final AddHalaqaStatus status;
  final List<TeacherSelectionModel> availableTeachers;
  final List<MosqueSelectionModel> availableMosques;
  final List<Map<String, dynamic>> halaqaTypes;
  final String? errorMessage;

  // إضافة متغيرات لتخزين الاختيارات
  final TeacherSelectionModel? selectedTeacher;
  final MosqueSelectionModel? selectedMosque;
  final Map<String, dynamic>? selectedHalaqaType;

  const AddHalaqaState({
    this.status = AddHalaqaStatus.initial,
    this.availableTeachers = const [],
    this.availableMosques = const [],
    this.halaqaTypes = const [],
    this.errorMessage,
    this.selectedTeacher,
    this.selectedMosque,
    this.selectedHalaqaType,
  });

  AddHalaqaState copyWith({
    AddHalaqaStatus? status,
    List<TeacherSelectionModel>? availableTeachers,
    List<MosqueSelectionModel>? availableMosques,
    List<Map<String, dynamic>>? halaqaTypes,
    String? errorMessage,
    TeacherSelectionModel? selectedTeacher,
    MosqueSelectionModel? selectedMosque,
    Map<String, dynamic>? selectedHalaqaType,
    bool unselectTeacher = false,
  }) {
    return AddHalaqaState(
      status: status ?? this.status,
      availableTeachers: availableTeachers ?? this.availableTeachers,
      availableMosques: availableMosques ?? this.availableMosques,
      halaqaTypes: halaqaTypes ?? this.halaqaTypes,
      errorMessage: errorMessage,
      selectedTeacher: unselectTeacher ? null : selectedTeacher ?? this.selectedTeacher,
      selectedMosque: selectedMosque ?? this.selectedMosque,
      selectedHalaqaType: selectedHalaqaType ?? this.selectedHalaqaType,
    );
  }

  @override
  List<Object?> get props => [status, availableTeachers, availableMosques, halaqaTypes, errorMessage, selectedTeacher, selectedMosque, selectedHalaqaType];
}
