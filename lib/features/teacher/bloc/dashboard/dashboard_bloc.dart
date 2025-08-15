// lib/features/teacher/blocs/dashboard/dashboard_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
 // Import failures
import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TeacherRepository _teacherRepository;

  DashboardBloc({required TeacherRepository teacherRepository})
      : _teacherRepository = teacherRepository,
        super(DashboardState()) {
    on<SyncAllDataRequested>(_onSyncAllDataRequested);
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
      LoadDashboardData event, Emitter<DashboardState> emit) async {
          print("🔵 [DashboardBloc] استدعاء _onLoadDashboardData() مع halaqaId = ${event.halaqaId}");
    emit(state.copyWith(status: DashboardStatus.loading));

    // Use .fold() to handle the Either result from the repository
    final result = await _teacherRepository.getDashboardSummary(halaqaId: event.halaqaId);
    result.fold(
      // Failure case (Left)
      (failure) {
        print("❌ [DashboardBloc] فشل الطلب: ${failure.message}");
        emit(state.copyWith(
          status: DashboardStatus.failure,
          error: failure.message,
        ));
      },
      // Success case (Right)
      (dashboardData) {
        print("✅ [DashboardBloc] تم تحميل البيانات بنجاح: $dashboardData");
        emit(state.copyWith(
          status: DashboardStatus.success,
          dashboardData: dashboardData,
        ));
      },
    );
  }

  Future<void> _onSyncAllDataRequested(
      SyncAllDataRequested event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(syncStatus: SyncStatus.syncing, syncError: null));

    // Use .fold() to handle the sync result
    final result = await _teacherRepository.syncAllUnsyncedData();
    result.fold(
      // Failure case (Left)
      (failure) {
        emit(state.copyWith(
          syncStatus: SyncStatus.failure,
          syncError: failure.message,
        ));
      },
      // Success case (Right)
      (isSynced) {
        emit(state.copyWith(syncStatus: SyncStatus.success));
        add(LoadDashboardData(halaqaId: event.halaqaId));
        // You can reload the dashboard data here if needed
        // add(LoadDashboardData(halaqaId: event.halaqaId));
      },
    );
  }
}