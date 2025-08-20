import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/ending_user_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/teacher_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'teacher_management_event.dart';
part 'teacher_management_state.dart';

class TeacherManagementBloc extends Bloc<TeacherManagementEvent, TeacherManagementState> {
  final SuperAdminRepository _repository;

  TeacherManagementBloc({required SuperAdminRepository repository})
      : _repository = repository,
        super(const TeacherManagementState()) {
    on<FetchApprovedTeachers>(_onFetchApproved);
    on<FetchMoreApprovedTeachers>(_onFetchMoreApproved);
    on<FetchPendingTeachers>(_onFetchPending);
    on<ApproveTeacherRequest>(_onApprove);
    on<RejectTeacherRequest>(_onReject);
  }

  Future<void> _onFetchApproved(FetchApprovedTeachers event, Emitter<TeacherManagementState> emit) async {
    emit(state.copyWith(approvedStatus: TeacherManagementStatus.loading, currentPage: 1, hasReachedMax: false));
    final result = await _repository.getApprovedTeachers(page: 1, searchQuery: event.searchQuery);
    result.fold(
      (failure) => emit(state.copyWith(approvedStatus: TeacherManagementStatus.failure, errorMessage: failure.message)),
      (paginatedData) {
        final teachers = (paginatedData['data'] as List).map((json) => Teacher.fromJson(json)).toList();
        emit(state.copyWith(
          approvedStatus: TeacherManagementStatus.success,
          approvedTeachers: teachers,
          hasReachedMax: paginatedData['next_page_url'] == null,
          currentPage: paginatedData['current_page'],
        ));
      },
    );
  }

  Future<void> _onFetchMoreApproved(FetchMoreApprovedTeachers event, Emitter<TeacherManagementState> emit) async {
    if (state.hasReachedMax || state.approvedStatus == TeacherManagementStatus.loading) return;

    emit(state.copyWith(approvedStatus: TeacherManagementStatus.loading));
    final nextPage = state.currentPage + 1;
    final result = await _repository.getApprovedTeachers(page: nextPage);

    result.fold(
      (failure) => emit(state.copyWith(approvedStatus: TeacherManagementStatus.failure, errorMessage: failure.message)),
      (paginatedData) {
        final newTeachers = (paginatedData['data'] as List).map((json) => Teacher.fromJson(json)).toList();
        emit(state.copyWith(
          approvedStatus: TeacherManagementStatus.success,
          approvedTeachers: List.of(state.approvedTeachers)..addAll(newTeachers),
          currentPage: paginatedData['current_page'],
          hasReachedMax: paginatedData['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onFetchPending(FetchPendingTeachers event, Emitter<TeacherManagementState> emit) async {
    emit(state.copyWith(pendingStatus: TeacherManagementStatus.loading));
    final result = await _repository.getPendingTeachers();
    result.fold(
      (failure) => emit(state.copyWith(pendingStatus: TeacherManagementStatus.failure, errorMessage: failure.message)),
      (users) => emit(state.copyWith(pendingStatus: TeacherManagementStatus.success, pendingTeachers: users)),
    );
  }

  Future<void> _onApprove(ApproveTeacherRequest event, Emitter<TeacherManagementState> emit) async {
    final result = await _repository.approveTeacher(event.userId);
    result.fold(
      (failure) { /* Handle error */ },
      (_) {
        final updatedList = List<PendingUser>.from(state.pendingTeachers)..removeWhere((u) => u.id == event.userId);
        emit(state.copyWith(pendingTeachers: updatedList, pendingStatus: TeacherManagementStatus.success));
        // Refresh the approved list after approval
        add(const FetchApprovedTeachers());
      },
    );
  }

  Future<void> _onReject(RejectTeacherRequest event, Emitter<TeacherManagementState> emit) async {
    final result = await _repository.rejectTeacher(event.userId);
    result.fold(
      (failure) { /* Handle error */ },
      (_) {
        final updatedList = List<PendingUser>.from(state.pendingTeachers)..removeWhere((u) => u.id == event.userId);
        emit(state.copyWith(pendingTeachers: updatedList, pendingStatus: TeacherManagementStatus.success));
      },
    );
  }
}
