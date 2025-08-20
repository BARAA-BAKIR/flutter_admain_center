// lib/features/center_manager/bloc/mosques_bloc/mosques_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'mosques_event.dart';
part 'mosques_state.dart';

const _throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return events.throttle(duration).switchMap(mapper);
  };
}

class MosquesBloc extends Bloc<MosquesEvent, MosquesState> {
  final CenterManagerRepository _repository;

  MosquesBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const MosquesState()) {
    on<FetchMosques>(_onFetchMosques);
    on<FetchMoreMosques>(_onFetchMoreMosques, transformer: throttleDroppable(_throttleDuration));
    on<DeleteMosque>(_onDeleteMosque);
    on<UpdateMosqueInList>(_onUpdateMosqueInList);
  }

  Future<void> _onFetchMosques(FetchMosques event, Emitter<MosquesState> emit) async {
    emit(state.copyWith(status: MosquesStatus.loading, clearError: true, clearSuccess: true));
    final result = await _repository.getMosques(page: 1, searchQuery: event.searchQuery);
    result.fold(
      (failure) => emit(state.copyWith(status: MosquesStatus.failure, errorMessage: failure.message)),
      (data) {
        final List<Mosque> mosques = (data['data'] as List).map((e) => Mosque.fromJson(e)).toList();
        emit(state.copyWith(
          status: MosquesStatus.success,
          mosques: mosques,
          currentPage: 1,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onFetchMoreMosques(FetchMoreMosques event, Emitter<MosquesState> emit) async {
    if (state.hasReachedMax) return;
    final result = await _repository.getMosques(page: state.currentPage + 1);
    result.fold(
      (failure) => emit(state.copyWith(status: MosquesStatus.failure, errorMessage: failure.message)),
      (data) {
        final List<Mosque> newMosques = (data['data'] as List).map((e) => Mosque.fromJson(e)).toList();
        emit(state.copyWith(
          status: MosquesStatus.success,
          mosques: List.of(state.mosques)..addAll(newMosques),
          currentPage: state.currentPage + 1,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onDeleteMosque(DeleteMosque event, Emitter<MosquesState> emit) async {
    final result = await _repository.deleteMosque(event.mosqueId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message, clearSuccess: true)),
      (successMessage) {
        final updatedList = state.mosques.where((m) => m.id != event.mosqueId).toList();
        emit(state.copyWith(
          mosques: updatedList,
          successMessage: successMessage,
          clearError: true,
        ));
      },
    );
  }
  void _onUpdateMosqueInList(UpdateMosqueInList event, Emitter<MosquesState> emit) {
    final updatedList = state.mosques.map((mosque) {
      return mosque.id == event.updatedMosque.id ? event.updatedMosque : mosque;
    }).toList();
    emit(state.copyWith(mosques: updatedList));
  }

}
