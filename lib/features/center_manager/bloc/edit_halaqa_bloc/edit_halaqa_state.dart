part of 'edit_halaqa_bloc.dart';

enum EditHalaqaStatus { initial, loading, success, failure, submitting }

class EditHalaqaState extends Equatable {
  final EditHalaqaStatus status;
  final List<TeacherSelectionModel> availableTeachers;
  final List<MosqueSelectionModel> availableMosques;
  final List<Map<String, dynamic>> halaqaTypes;
  final String? errorMessage;

  final TeacherSelectionModel? selectedTeacher;
  final MosqueSelectionModel? selectedMosque;
  final Map<String, dynamic>? selectedHalaqaType;
  
  final Map<String, dynamic>? initialHalaqaData;

  const EditHalaqaState({
    this.status = EditHalaqaStatus.initial,
    this.availableTeachers = const [],
    this.availableMosques = const [],
    this.halaqaTypes = const [],
    this.errorMessage,
    this.selectedTeacher,
    this.selectedMosque,
    this.selectedHalaqaType,
    this.initialHalaqaData,
  });

  // ==================== هنا هو الإصلاح الكامل والدقيق ====================
  EditHalaqaState copyWith({
    EditHalaqaStatus? status,
    List<TeacherSelectionModel>? availableTeachers,
    List<MosqueSelectionModel>? availableMosques,
    List<Map<String, dynamic>>? halaqaTypes,
    String? errorMessage,
    TeacherSelectionModel? selectedTeacher,
    MosqueSelectionModel? selectedMosque,
    Map<String, dynamic>? selectedHalaqaType,
    Map<String, dynamic>? initialHalaqaData,
    bool clearInitialData = false,
    bool unselectTeacher = false, //  إضافة المعلمة الناقصة هنا
  }) {
    return EditHalaqaState(
      status: status ?? this.status,
      availableTeachers: availableTeachers ?? this.availableTeachers,
      availableMosques: availableMosques ?? this.availableMosques,
      halaqaTypes: halaqaTypes ?? this.halaqaTypes,
      errorMessage: errorMessage,
      // إذا كانت unselectTeacher صحيحة، قم بتعيين الأستاذ إلى null
      selectedTeacher: unselectTeacher ? null : selectedTeacher ?? this.selectedTeacher,
      selectedMosque: selectedMosque ?? this.selectedMosque,
      selectedHalaqaType: selectedHalaqaType ?? this.selectedHalaqaType,
      initialHalaqaData: clearInitialData ? null : initialHalaqaData ?? this.initialHalaqaData,
    );
  }
  // ====================================================================

  @override
  List<Object?> get props => [status, availableTeachers, availableMosques, halaqaTypes, errorMessage, selectedTeacher, selectedMosque, selectedHalaqaType, initialHalaqaData];
}
