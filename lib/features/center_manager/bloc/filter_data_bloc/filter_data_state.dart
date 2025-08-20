part of 'filter_data_bloc.dart';

enum FilterDataStatus { initial, loading, success, failure }

class FilterDataState extends Equatable {
  const FilterDataState({
    this.status = FilterDataStatus.initial,
    this.halaqas = const [],
    this.errorMessage,
  });

  final FilterDataStatus status;
  final List<Map<String, dynamic>> halaqas;
  final String? errorMessage;

  FilterDataState copyWith({
    FilterDataStatus? status,
    List<Map<String, dynamic>>? halaqas,
    String? errorMessage,
  }) {
    return FilterDataState(
      status: status ?? this.status,
      halaqas: halaqas ?? this.halaqas,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, halaqas, errorMessage];
}
