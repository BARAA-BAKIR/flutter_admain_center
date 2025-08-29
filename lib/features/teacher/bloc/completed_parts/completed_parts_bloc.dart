// In lib/features/teacher/bloc/completed_parts/completed_parts_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

part 'completed_parts_event.dart';
part 'completed_parts_state.dart';

class CompletedPartsBloc extends Bloc<CompletedPartsEvent, CompletedPartsState> {
  final TeacherRepository _repository;

  CompletedPartsBloc({required TeacherRepository repository})
      : _repository = repository,
        super(const CompletedPartsState()) {
    on<LoadStudentParts>(_onLoadParts);
    on<TogglePartSelection>(_onToggleSelection);
    on<SyncCompletedParts>(_onSyncParts);
  }

  Future<void> _onLoadParts(LoadStudentParts event, Emitter<CompletedPartsState> emit) async {
    emit(state.copyWith(status: PartsStatus.loading));
    final result = await _repository.getPartsForStudent(event.studentId);
    result.fold(
      (failure) => emit(state.copyWith(status: PartsStatus.failure, errorMessage: failure.message)),
      (partsData) => emit(state.copyWith(status: PartsStatus.success, parts: partsData)),
    );
  }

  void _onToggleSelection(TogglePartSelection event, Emitter<CompletedPartsState> emit) {
    final updatedParts = state.parts.map((part) {
      if (part['id'] == event.partId) {
        return {...part, 'is_completed': !part['is_completed']};
      }
      return part;
    }).toList();
    emit(state.copyWith(parts: updatedParts));
  }

  Future<void> _onSyncParts(SyncCompletedParts event, Emitter<CompletedPartsState> emit) async {
    emit(state.copyWith(status: PartsStatus.submitting));
    final selectedIds = state.parts
        .where((part) => part['is_completed'] == true)
        .map((part) => part['id'] as int)
        .toList();

    final result = await _repository.syncStudentParts(event.studentId, selectedIds);
    result.fold(
      (failure) => emit(state.copyWith(status: PartsStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: PartsStatus.success)), // Go back to success state
    );
  }
}
