
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_filter_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_details_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_list_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

import '../../../../data/models/super_admin/student_progress_stage_model.dart';

part 'all_students_event.dart';
part 'all_students_state.dart';

class AllStudentsBloc extends Bloc<AllStudentsEvent, AllStudentsState> {
  final SuperAdminRepository repository;

  AllStudentsBloc({required this.repository})
    : super(const AllStudentsState()) {
    // أحداث قائمة الطلاب
    on<FetchAllStudents>(_onFetchStudents);
    on<FetchMoreAllStudents>(_onFetchMoreStudents);
    on<DeleteStudent>(_onDeleteStudent);
 on<FormValueChanged>(_onFormValueChanged);
    // أحداث نموذج الإضافة/التعديل
    on<LoadDataForStudentForm>(_onLoadDataForForm);
    on<CenterSelected>(_onCenterSelected);
    on<AddNewStudent>(_onAddNewStudent);
    on<UpdateStudentDetails>(_onUpdateStudentDetails);
  }

  // --- معالجات أحداث قائمة الطلاب ---

  Future<void> _onFetchStudents(
    FetchAllStudents event,
    Emitter<AllStudentsState> emit,
  ) async {
    emit(
      state.copyWith(
        listStatus: ListStatus.loading,
        searchQuery: event.searchQuery,
        currentPage: 1,
        hasReachedMax: false,
      ),
    );
    final result = await repository.getAllStudents(
      page: 1,
      searchQuery: event.searchQuery,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          listStatus: ListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (paginatedResponse) => emit(
        state.copyWith(
          listStatus: ListStatus.success,
          students: paginatedResponse.data,
          hasReachedMax:
              paginatedResponse.currentPage >= paginatedResponse.lastPage,
          currentPage: 1,
        ),
      ),
    );
  }

  Future<void> _onFetchMoreStudents(
    FetchMoreAllStudents event,
    Emitter<AllStudentsState> emit,
  ) async {
    if (state.hasReachedMax || state.listStatus == ListStatus.loading) return;

    emit(state.copyWith(listStatus: ListStatus.loading));
    final nextPage = state.currentPage + 1;
    final result = await repository.getAllStudents(
      page: nextPage,
      searchQuery: state.searchQuery,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          listStatus: ListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (paginatedResponse) => emit(
        state.copyWith(
          listStatus: ListStatus.success,
          students: List.of(state.students)..addAll(paginatedResponse.data),
          hasReachedMax:
              paginatedResponse.currentPage >= paginatedResponse.lastPage,
          currentPage: nextPage,
        ),
      ),
    );
  }

  Future<void> _onDeleteStudent(
    DeleteStudent event,
    Emitter<AllStudentsState> emit,
  ) async {
    final result = await repository.deleteStudent(event.studentId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedList = List<StudentListItem>.from(state.students)
          ..removeWhere((s) => s.id == event.studentId);
        emit(state.copyWith(students: updatedList));
      },
    );
  }
  Future<void> _onLoadDataForForm(LoadDataForStudentForm event, Emitter<AllStudentsState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    final results = await Future.wait([
      repository.getCentersForFilter(),
      repository.getProgressStagesForFilter(),
    ]);

    final centers = (results[0] as Either<Failure, List<Map<String, dynamic>>>)
        .fold((l) => <CenterFilterModel>[], (r) => r.map((json) => CenterFilterModel.fromJson(json)).toList());
    final stages = (results[1] as Either<Failure, List<StudentProgressStage>>)
        .fold((l) => <Map<String, dynamic>>[], (r) => r.map((stage) => stage.toJson()).toList());

    if (event.studentId == null) {
      emit(state.copyWith(formStatus: FormStatus.loaded, filterCenters: centers, progressStages: stages));
      return;
    }

    final detailsResult = await repository.getStudentDetails(event.studentId!);
    await detailsResult.fold(
      (failure) async => emit(state.copyWith(formStatus: FormStatus.failure, errorMessage: failure.message)),
      (details) async {
        var newState = state.copyWith(
          filterCenters: centers,
          progressStages: stages,
          studentDetails: details,
          selectedCenterId: details.centerId,
          selectedHalaqaId: details.halaqaId,
          selectedLevelId: details.levelId,
          selectedGender: details.gender ?? 'ذكر',
          selectedBirthDate: details.birthDate != null && details.birthDate!.isNotEmpty ? DateTime.tryParse(details.birthDate!) : null,
          isOneParentDeceased: details.isOneParentDeceased ?? false,
        );

        if (details.centerId != null) {
          final halaqasResult = await repository.getHalaqasForFilter(details.centerId!);
          final halaqas = halaqasResult.getOrElse(() => []);
          newState = newState.copyWith(filterHalaqas: halaqas);
        }
        emit(newState.copyWith(formStatus: FormStatus.loaded));
      },
    );
  }

  Future<void> _onCenterSelected(CenterSelected event, Emitter<AllStudentsState> emit) async {
    emit(state.copyWith(selectedCenterId: event.centerId, forceNullHalaqa: true, filterHalaqas: []));
    if (event.centerId != null) {
      final result = await repository.getHalaqasForFilter(event.centerId!);
      result.fold(
        (failure) => emit(state.copyWith(filterHalaqas: [])),
        (halaqas) => emit(state.copyWith(filterHalaqas: halaqas)),
      );
    }
  }

  void _onFormValueChanged(FormValueChanged event, Emitter<AllStudentsState> emit) {
    emit(state.copyWith(
      selectedHalaqaId: event.halaqaId,
      selectedLevelId: event.levelId,
      selectedGender: event.gender,
      selectedBirthDate: event.birthDate,
      isOneParentDeceased: event.isOneParentDeceased,
    ));
  }

  Future<void> _onAddNewStudent(AddNewStudent event, Emitter<AllStudentsState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.submitting));
    final result = await repository.addStudentBySuperAdmin(event.data);
    result.fold(
      (failure) => emit(state.copyWith(formStatus: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(formStatus: FormStatus.success)),
    );
  }

  Future<void> _onUpdateStudentDetails(UpdateStudentDetails event, Emitter<AllStudentsState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.submitting));
    final result = await repository.updateStudentBySuperAdmin(event.studentId, event.data);
    result.fold(
      (failure) => emit(state.copyWith(formStatus: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(formStatus: FormStatus.success)),
    );
  }
}
