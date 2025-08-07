import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/dashboard_summary_model.dart';
import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
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
    final result = await centerManagerRepository.getDashboardSummary();
    
    result.fold(
      (failure) => emit(state.copyWith(status: DashboardStatus.failure, errorMessage: failure.message)),
      (summary) => emit(state.copyWith(status: DashboardStatus.success, summary: summary)),
    );
  }
}
