// In lib/features/center_manager/bloc/halaqa_details_bloc/halaqa_details_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// تأكد من أن هذا هو المسار الصحيح لـ Halaqa Model
import 'package:flutter_admain_center/data/models/center_maneger/halaqa_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'halaqa_details_event.dart';
part 'halaqa_details_state.dart';

class HalaqaDetailsBloc extends Bloc<HalaqaDetailsEvent, HalaqaDetailsState> {
  final CenterManagerRepository _repository;

  HalaqaDetailsBloc({required CenterManagerRepository repository})
    : _repository = repository,
      super(const HalaqaDetailsState()) {
    on<FetchHalaqaDetails>(_onFetchHalaqaDetails);
  }

  Future<void> _onFetchHalaqaDetails(
    FetchHalaqaDetails event,
    Emitter<HalaqaDetailsState> emit,
  ) async {
    emit(state.copyWith(status: HalaqaDetailsStatus.loading));

    final result = await _repository.getHalaqaDetails(event.halaqaId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HalaqaDetailsStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (halaqaObject) {
        final Halaqa? nullableHalaqa = halaqaObject;
        emit(
          state.copyWith(
            status: HalaqaDetailsStatus.success,
            halaqa: nullableHalaqa,
          ),
        );
        // =====================================================================
      },
    );
  }
}
