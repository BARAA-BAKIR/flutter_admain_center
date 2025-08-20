import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_model.dart'; // ✅ استيراد المودل
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'centers_event.dart';
part 'centers_state.dart';

class CentersBloc extends Bloc<CentersEvent, CentersState> {
  final SuperAdminRepository _repository;

  CentersBloc({required SuperAdminRepository repository})
      : _repository = repository,
        super(const CentersState()) {
    on<FetchCenters>(_onFetchCenters);
    on<FetchMoreCenters>(_onFetchMoreCenters);
    on<DeleteCenter>(_onDeleteCenter);
  }

  Future<void> _onFetchCenters(FetchCenters event, Emitter<CentersState> emit) async {
    emit(state.copyWith(status: CentersStatus.loading, currentPage: 1, hasReachedMax: false));
    final result = await _repository.getCenters(page: 1, searchQuery: event.searchQuery);
    result.fold(
      (failure) => emit(state.copyWith(status: CentersStatus.failure, errorMessage: failure.message)),
      (paginatedData) {
        final centers = (paginatedData['data'] as List).map((centerJson) => CenterModel.fromJson(centerJson)).toList();
        emit(state.copyWith(
          status: CentersStatus.success,
          centers: centers,
          hasReachedMax: paginatedData['next_page_url'] == null,
          currentPage: paginatedData['current_page'],
        ));
      },
    );
  }

  Future<void> _onFetchMoreCenters(FetchMoreCenters event, Emitter<CentersState> emit) async {
    if (state.hasReachedMax || state.status == CentersStatus.loading) return;
    
    emit(state.copyWith(status: CentersStatus.loading)); // Show loading for pagination
    final nextPage = state.currentPage + 1;
    final result = await _repository.getCenters(page: nextPage);
    
    result.fold(
      (failure) => emit(state.copyWith(status: CentersStatus.failure, errorMessage: failure.message)),
      (paginatedData) {
        final newCenters = (paginatedData['data'] as List).map((centerJson) => CenterModel.fromJson(centerJson)).toList();
        emit(state.copyWith(
          status: CentersStatus.success,
          centers: List.of(state.centers)..addAll(newCenters),
          currentPage: paginatedData['current_page'],
          hasReachedMax: paginatedData['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onDeleteCenter(DeleteCenter event, Emitter<CentersState> emit) async {
    final result = await _repository.deleteCenter(event.centerId);
    result.fold(
      (failure) { /* Optionally emit a state to show an error SnackBar */ },
      (_) {
        final updatedList = List<CenterModel>.from(state.centers)..removeWhere((c) => c.id == event.centerId);
        emit(state.copyWith(centers: updatedList, status: CentersStatus.success));
      },
    );
  }
}
