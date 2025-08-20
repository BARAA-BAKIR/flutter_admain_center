// features/super_admin/bloc/dashboard_bloc/dashboard_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SuperAdminRepository _superAdminRepository;

  DashboardBloc({required SuperAdminRepository superAdminRepository})
      : _superAdminRepository = superAdminRepository,
        super(const DashboardState()) {
    on<FetchSuperAdminDashboard>(_onFetchDashboard);
  }

  Future<void> _onFetchDashboard(
    FetchSuperAdminDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    // Emit loading state immediately
    emit(state.copyWith(status: DashboardStatus.loading));

    // Fetch data from the repository
    final result = await _superAdminRepository.getDashboardSummary();

    // Use fold to handle success and failure cases
    result.fold(
      (failure) {
        // On failure, emit failure state with the error message
        emit(state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        // On success, emit success state with the fetched data
        emit(state.copyWith(
          status: DashboardStatus.success,
          globalStats: Map<String, dynamic>.from(data['global_stats'] ?? {}),
          topCenters: List<Map<String, dynamic>>.from(data['top_centers'] ?? []),
          performanceChartData: List<Map<String, dynamic>>.from(data['performance_chart'] ?? []),
        ));
      },
    );
  }
}
