import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'filter_data_event.dart';
part 'filter_data_state.dart';

class FilterDataBloc extends Bloc<FilterDataEvent, FilterDataState> {
  final CenterManagerRepository _repository;

  FilterDataBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const FilterDataState()) {
    on<LoadFilterData>(_onLoadFilterData);
  }

  Future<void> _onLoadFilterData(
    LoadFilterData event,
    Emitter<FilterDataState> emit,
  ) async {
    emit(state.copyWith(status: FilterDataStatus.loading));
    
    final halaqasResult = await _repository.getHalaqasForFilter();
    
    halaqasResult.fold(
      (failure) => emit(state.copyWith(
        status: FilterDataStatus.failure,
        errorMessage: failure.message,
      )),
      (halaqas) => emit(state.copyWith(
        status: FilterDataStatus.success,
        halaqas: halaqas,
      )),
    );
  }
}
