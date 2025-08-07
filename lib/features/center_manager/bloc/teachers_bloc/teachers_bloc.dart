import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_model.dart';

import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'teachers_event.dart';
part 'teachers_state.dart';

class TeachersBloc extends Bloc<TeachersEvent, TeachersState> {
  final CenterManagerRepository centerManagerRepository;

  TeachersBloc({required this.centerManagerRepository}) : super(const TeachersState()) {
    on<FetchTeachers>(_onFetchTeachers);
    on<FetchMoreTeachers>(_onFetchMoreTeachers);
  }

  Future<void> _onFetchTeachers(FetchTeachers event, Emitter<TeachersState> emit) async {
    emit(state.copyWith(status: TeachersStatus.loading));
    final result = await centerManagerRepository.getTeachers(page: 1, searchQuery: event.searchQuery);
    
    result.fold(
      (failure) => emit(state.copyWith(status: TeachersStatus.failure, errorMessage: failure.message)),
      (data) {
        final List<dynamic> listJson = data['data'];
        final items = listJson.map((json) => Teacher.fromJson(json)).toList();
        emit(state.copyWith(
          status: TeachersStatus.success,
          teachers: items,
          currentPage: 1,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onFetchMoreTeachers(FetchMoreTeachers event, Emitter<TeachersState> emit) async {
    if (state.hasReachedMax) return;

    final nextPage = state.currentPage + 1;
    final result = await centerManagerRepository.getTeachers(page: nextPage);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (data) {
        final List<dynamic> listJson = data['data'];
        final newItems = listJson.map((json) => Teacher.fromJson(json)).toList();
        emit(state.copyWith(
          status: TeachersStatus.success,
          teachers: List.of(state.teachers)..addAll(newItems),
          currentPage: nextPage,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }
}
