part of 'halaqas_bloc.dart';

enum HalaqasStatus { initial, loading, success, failure }

class HalaqasState extends Equatable {
  final HalaqasStatus status;
  final List<Halaqa> halaqas;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;

  const HalaqasState({
    this.status = HalaqasStatus.initial,
    this.halaqas = const <Halaqa>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  HalaqasState copyWith({
    HalaqasStatus? status,
    List<Halaqa>? halaqas,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return HalaqasState(
      status: status ?? this.status,
      halaqas: halaqas ?? this.halaqas,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, halaqas, hasReachedMax, currentPage, errorMessage];
}
