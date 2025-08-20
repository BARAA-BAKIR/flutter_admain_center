import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_list_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'all_students_event.dart';
part 'all_students_state.dart';

class AllStudentsBloc extends Bloc<AllStudentsEvent, AllStudentsState> {
  final SuperAdminRepository _repository;

  AllStudentsBloc({required SuperAdminRepository repository})
      : _repository = repository,
        super(const AllStudentsState()) {
    on<FetchAllStudents>(_onFetch);
    on<FetchMoreAllStudents>(_onFetchMore);
  }

  Future<void> _onFetch(FetchAllStudents event, Emitter<AllStudentsState> emit) async {
    emit(state.copyWith(
      status: AllStudentsStatus.loading,
      currentPage: 1,
      hasReachedMax: false,
      searchQuery: event.searchQuery,
      centerId: event.centerId,
      halaqaId: event.halaqaId,
    ));
    
    final result = await _repository.getAllStudents(
      page: 1,
      searchQuery: event.searchQuery,
      centerId: event.centerId,
      halaqaId: event.halaqaId,
    );

    result.fold(
      (failure) => emit(state.copyWith(status: AllStudentsStatus.failure, errorMessage: failure.message)),
      (paginatedData) {
        final students = (paginatedData['data'] as List).map((json) => StudentListItem.fromJson(json)).toList();
        emit(state.copyWith(
          status: AllStudentsStatus.success,
          students: students,
          hasReachedMax: paginatedData['next_page_url'] == null,
          currentPage: paginatedData['current_page'],
        ));
      },
    );
  }

  Future<void> _onFetchMore(FetchMoreAllStudents event, Emitter<AllStudentsState> emit) async {
    if (state.hasReachedMax || state.status == AllStudentsStatus.loading) return;
    
    emit(state.copyWith(status: AllStudentsStatus.loading));
    final nextPage = state.currentPage + 1;
    
    final result = await _repository.getAllStudents(
      page: nextPage,
      searchQuery: state.searchQuery,
      centerId: state.centerId,
      halaqaId: state.halaqaId,
    );

    result.fold(
      (failure) => emit(state.copyWith(status: AllStudentsStatus.failure, errorMessage: failure.message)),
      (paginatedData) {
        final newStudents = (paginatedData['data'] as List).map((json) => StudentListItem.fromJson(json)).toList();
        emit(state.copyWith(
          status: AllStudentsStatus.success,
          students: List.of(state.students)..addAll(newStudents),
          currentPage: paginatedData['current_page'],
          hasReachedMax: paginatedData['next_page_url'] == null,
        ));
      },
    );
  }
}
