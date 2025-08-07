part of 'filter_bloc.dart';


enum FilterStatus { initial, loading, success, failure }

class FilterState extends Equatable {
  final FilterStatus status;
  // قائمة الحلقات المتاحة للفلترة
  final List<Map<String, dynamic>> halaqas;
  // قائمة المراحل المتاحة للفلترة
  final List<Map<String, dynamic>> levels;
  final String? errorMessage;

  const FilterState({
    this.status = FilterStatus.initial,
    this.halaqas = const [],
    this.levels = const [],
    this.errorMessage,
  });

  FilterState copyWith({
    FilterStatus? status,
    List<Map<String, dynamic>>? halaqas,
    List<Map<String, dynamic>>? levels,
    String? errorMessage,
  }) {
    return FilterState(
      status: status ?? this.status,
      halaqas: halaqas ?? this.halaqas,
      levels: levels ?? this.levels,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, halaqas, levels, errorMessage];
}
