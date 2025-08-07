import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final CenterManagerRepository _repository;

  FilterBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const FilterState()) {
    on<LoadFilterData>(_onLoadFilterData);
  }

  Future<void> _onLoadFilterData(LoadFilterData event, Emitter<FilterState> emit) async {
    emit(state.copyWith(status: FilterStatus.loading));
    final result = await _repository.getFiltersData();
    result.fold(
      (failure) => emit(state.copyWith(status: FilterStatus.failure, errorMessage: failure.message)),
      (data) {
        // استخراج القوائم من البيانات المرتجعة
        final halaqas = List<Map<String, dynamic>>.from(data['halaqas'] ?? []);
        final levels = List<Map<String, dynamic>>.from(data['levels'] ?? []);
        emit(state.copyWith(
          status: FilterStatus.success,
          halaqas: halaqas,
          levels: levels,
        ));
      },
    );
  }
}
