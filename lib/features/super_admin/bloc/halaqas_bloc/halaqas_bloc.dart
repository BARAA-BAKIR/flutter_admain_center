import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'halaqas_event.dart';
part 'halaqas_state.dart';

class HalaqasBloc extends Bloc<HalaqasEvent, HalaqasState> {
  final SuperAdminRepository repository;

  HalaqasBloc({required this.repository}) : super(HalaqasInitial()) {
    on<FetchHalaqas>(_onFetchHalaqas);
    on<DeleteHalaqa>(_onDelete); // ✅
  }

  Future<void> _onFetchHalaqas(FetchHalaqas event, Emitter<HalaqasState> emit) async {
    emit(HalaqasLoading());
    final result = await repository.getHalaqas(searchQuery: event.searchQuery);
    result.fold(
      (failure) => emit(HalaqasError(failure.message)),
      (halaqas) => emit(HalaqasLoaded(halaqas)),
    );
  }

  // ✅ معالج حدث الحذف
  Future<void> _onDelete(DeleteHalaqa event, Emitter<HalaqasState> emit) async {
    final currentState = state;
    if (currentState is HalaqasLoaded) {
      final result = await repository.deleteHalaqa(event.id);
      result.fold(
        (failure) { /* يمكنك إظهار خطأ هنا */ },
        (_) {
          final updatedList = List<HalaqaModel>.from(currentState.halaqas)..removeWhere((h) => h.id == event.id);
          emit(HalaqasLoaded(updatedList));
        },
      );
    }
  }
}
