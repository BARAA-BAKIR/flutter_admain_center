import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/dashboard_summary_model.dart';

import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final CenterManagerRepository centerManagerRepository;

  DashboardBloc({required this.centerManagerRepository}) : super(const DashboardState()) {
    on<FetchDashboardSummary>(_onFetchDashboardSummary);
  }

  Future<void> _onFetchDashboardSummary(FetchDashboardSummary event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(status: DashboardStatus.loading));
     print("🔵 [BLOC] 6. FetchDashboardSummary event received. Calling repository...");
    // ========================================================
    final result = await centerManagerRepository.getDashboardSummary();

    result.fold(
      (failure) {
        // ==================== DEBUGGING CODE ====================
        print("❌ [BLOC] 7a. Repository returned a Failure. Emitting failure state. Message: ${failure.message}");
        // ========================================================
        emit(state.copyWith(status: DashboardStatus.failure, errorMessage: failure.message));
      },
      (summary) {
        // ==================== DEBUGGING CODE ====================
        print("✅ [BLOC] 7b. Repository returned a Success. Emitting success state with summary data.");
        // ========================================================
        emit(state.copyWith(status: DashboardStatus.success, summary: summary));
      },
    );
  }
}
