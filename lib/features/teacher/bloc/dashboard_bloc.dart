import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TeacherRepository _teacherRepository;

  DashboardBloc({required TeacherRepository teacherRepository})
      : _teacherRepository = teacherRepository,
        super(const DashboardState()) {
    on<SyncAllDataRequested>(_onSyncAllDataRequested);
  }

  Future<void> _onSyncAllDataRequested(SyncAllDataRequested event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(syncStatus: SyncStatus.syncing, syncError: null));
    try {
      await _teacherRepository.syncAllUnsyncedData();
      emit(state.copyWith(syncStatus: SyncStatus.success));
    } catch (e) {
      emit(state.copyWith(syncStatus: SyncStatus.failure, syncError: e.toString()));
    }
  }
}
