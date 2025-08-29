import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/mosque_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'mosques_event.dart';
part 'mosques_state.dart';

class MosquesBloc extends Bloc<MosquesEvent, MosquesState> {
  final SuperAdminRepository repository;

  MosquesBloc({required this.repository}) : super(const MosquesState()) {
    on<FetchMosques>(_onFetch);
    on<FetchMoreMosques>(_onFetchMore);
    on<DeleteMosque>(_onDelete);
    on<AddMosque>(_onAdd); // ✅
    on<UpdateMosque>(_onUpdate); // ✅
   
  }

  Future<void> _onFetch(FetchMosques event, Emitter<MosquesState> emit) async {
    emit(
      state.copyWith(
        status: MosquesStatus.loading,
        currentPage: 1,
        hasReachedMax: false,
      ),
    );
    final result = await repository.getMosques(
      page: 1,
      searchQuery: event.searchQuery,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MosquesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (paginatedData) {
        final mosques =
            (paginatedData['data'] as List)
                .map((json) => MosqueModel.fromJson(json))
                .toList();
        emit(
          state.copyWith(
            status: MosquesStatus.success,
            mosques: mosques,
            hasReachedMax: paginatedData['next_page_url'] == null,
            currentPage: paginatedData['current_page'],
          ),
        );
      },
    );
  }

  Future<void> _onFetchMore(
    FetchMoreMosques event,
    Emitter<MosquesState> emit,
  ) async {
    if (state.hasReachedMax || state.status == MosquesStatus.loading) return;
    emit(state.copyWith(status: MosquesStatus.loading));
    final nextPage = state.currentPage + 1;
    final result = await repository.getMosques(page: nextPage);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MosquesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (paginatedData) {
        final newMosques =
            (paginatedData['data'] as List)
                .map((json) => MosqueModel.fromJson(json))
                .toList();
        emit(
          state.copyWith(
            status: MosquesStatus.success,
            mosques: List.of(state.mosques)..addAll(newMosques),
            currentPage: paginatedData['current_page'],
            hasReachedMax: paginatedData['next_page_url'] == null,
          ),
        );
      },
    );
  }

  // ✅ معالج حدث الإضافة
  Future<void> _onAdd(AddMosque event, Emitter<MosquesState> emit) async {
    final result = await repository.addMosque(event.data);
    result.fold(
      (failure) {
        /* يمكنك إظهار خطأ هنا */
      },
      (_) =>
          add(const FetchMosques()), // أعد تحميل القائمة لإظهار المسجد الجديد
    );
  }

  // ✅ معالج حدث التعديل
  Future<void> _onUpdate(UpdateMosque event, Emitter<MosquesState> emit) async {
    final result = await repository.updateMosque(
      id: event.id,
      data: event.data,
    );
    result.fold(
      (failure) {
        /* يمكنك إظهار خطأ هنا */
      },
      (_) => add(const FetchMosques()), // أعد تحميل القائمة لإظهار التعديلات
    );
  }

  // ✅ معالج حدث الحذف
  Future<void> _onDelete(DeleteMosque event, Emitter<MosquesState> emit) async {
    final result = await repository.deleteMosque(event.id);
    result.fold(
      (failure) {
        /* يمكنك إظهار خطأ هنا */
      },
      (_) {
        final updatedList = List<MosqueModel>.from(state.mosques)
          ..removeWhere((m) => m.id == event.id);
        emit(state.copyWith(mosques: updatedList));
      },
    );
  }
}
