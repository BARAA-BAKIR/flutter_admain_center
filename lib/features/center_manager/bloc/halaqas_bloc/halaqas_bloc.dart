import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/halaqa_model.dart';

import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'halaqas_event.dart';
part 'halaqas_state.dart';

class HalaqasBloc extends Bloc<HalaqasEvent, HalaqasState> {
  final CenterManagerRepository centerManagerRepository;

  HalaqasBloc({required this.centerManagerRepository}) : super(const HalaqasState()) {
    on<FetchHalaqas>(_onFetchHalaqas);
    on<FetchMoreHalaqas>(_onFetchMoreHalaqas);
     on<DeleteHalaqa>(_onDeleteHalaqa);
  }

  Future<void> _onFetchHalaqas(FetchHalaqas event, Emitter<HalaqasState> emit) async {
    emit(state.copyWith(status: HalaqasStatus.loading));
    final result = await centerManagerRepository.getHalaqas(page: 1, searchQuery: event.searchQuery);
    
    result.fold(
      (failure) => emit(state.copyWith(status: HalaqasStatus.failure, errorMessage: failure.message)),
      (data) {
        final List<dynamic> listJson = data['data'];
        final items = listJson.map((json) => Halaqa.fromJson(json)).toList();
        emit(state.copyWith(
          status: HalaqasStatus.success,
          halaqas: items,
          currentPage: 1,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onFetchMoreHalaqas(FetchMoreHalaqas event, Emitter<HalaqasState> emit) async {
    if (state.hasReachedMax) return;

    final nextPage = state.currentPage + 1;
    final result = await centerManagerRepository.getHalaqas(page: nextPage);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)), // يمكنك تحديث الخطأ فقط
      (data) {
        final List<dynamic> listJson = data['data'];
        final newItems = listJson.map((json) => Halaqa.fromJson(json)).toList();
        emit(state.copyWith(
          status: HalaqasStatus.success,
          halaqas: List.of(state.halaqas)..addAll(newItems),
          currentPage: nextPage,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }
  Future<void> _onDeleteHalaqa(DeleteHalaqa event, Emitter<HalaqasState> emit) async {
        final result = await centerManagerRepository.deleteHalaqa(event.halaqaId);
        result.fold(
            (failure) { /* يمكنك إرسال حالة خطأ هنا */ },
            (_) {
                final updatedList = List<Halaqa>.from(state.halaqas)
                    ..removeWhere((h) => h.id == event.halaqaId);
                emit(state.copyWith(halaqas: updatedList));
            },
        );
    }
}
