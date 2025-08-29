part of 'all_students_bloc.dart';

enum FormStatus { initial, loading, loaded, submitting, success, failure }
enum ListStatus { initial, loading, success, failure }

class AllStudentsState extends Equatable {
  // حالة قائمة الطلاب
  final ListStatus listStatus;
  final List<StudentListItem> students;
  final bool hasReachedMax;
  final int currentPage;
  final String searchQuery;

  // حالة النموذج
  final FormStatus formStatus;
  final String? errorMessage;
  final StudentDetails? studentDetails;
  final List<CenterFilterModel> filterCenters;
  final List<Map<String, dynamic>> filterHalaqas;
  final List<Map<String, dynamic>> progressStages;

  // القيم المختارة في النموذج
  final int? selectedCenterId;
  final int? selectedHalaqaId;
  final int? selectedLevelId;
  final String selectedGender;
  final DateTime? selectedBirthDate;
  final bool isOneParentDeceased;

  const AllStudentsState({
    this.listStatus = ListStatus.initial,
    this.students = const [],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.searchQuery = '',
    this.formStatus = FormStatus.initial,
    this.errorMessage,
    this.studentDetails,
    this.filterCenters = const [],
    this.filterHalaqas = const [],
    this.progressStages = const [],
    this.selectedCenterId,
    this.selectedHalaqaId,
    this.selectedLevelId,
    this.selectedGender = 'ذكر',
    this.selectedBirthDate,
    this.isOneParentDeceased = false,
  });

  AllStudentsState copyWith({
    ListStatus? listStatus,
    List<StudentListItem>? students,
    bool? hasReachedMax,
    int? currentPage,
    String? searchQuery,
    FormStatus? formStatus,
    String? errorMessage,
    StudentDetails? studentDetails,
    List<CenterFilterModel>? filterCenters,
    List<Map<String, dynamic>>? filterHalaqas,
    List<Map<String, dynamic>>? progressStages,
    int? selectedCenterId,
    int? selectedHalaqaId,
    int? selectedLevelId,
    String? selectedGender,
    DateTime? selectedBirthDate,
    bool? isOneParentDeceased,
    bool forceNullHalaqa = false,
  }) {
    return AllStudentsState(
      listStatus: listStatus ?? this.listStatus,
      students: students ?? this.students,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage,
      studentDetails: studentDetails ?? this.studentDetails,
      filterCenters: filterCenters ?? this.filterCenters,
      filterHalaqas: filterHalaqas ?? this.filterHalaqas,
      progressStages: progressStages ?? this.progressStages,
      selectedCenterId: selectedCenterId ?? this.selectedCenterId,
      selectedHalaqaId: forceNullHalaqa ? null : selectedHalaqaId ?? this.selectedHalaqaId,
      selectedLevelId: selectedLevelId ?? this.selectedLevelId,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedBirthDate: selectedBirthDate ?? this.selectedBirthDate,
      isOneParentDeceased: isOneParentDeceased ?? this.isOneParentDeceased,
    );
  }

  @override
  List<Object?> get props => [
        listStatus, students, hasReachedMax, currentPage, searchQuery,
        formStatus, errorMessage, studentDetails, filterCenters, filterHalaqas, progressStages,
        selectedCenterId, selectedHalaqaId, selectedLevelId, selectedGender,
        selectedBirthDate, isOneParentDeceased,
      ];
}
