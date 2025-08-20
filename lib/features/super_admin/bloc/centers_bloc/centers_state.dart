part of 'centers_bloc.dart';

enum CentersStatus { initial, loading, success, failure }

class CentersState extends Equatable {
  final CentersStatus status;
  final List<CenterModel> centers; // Assuming a Center model
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;

  const CentersState({
    this.status = CentersStatus.initial,
    this.centers = const <CenterModel>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  CentersState copyWith({
    CentersStatus? status,
    List<CenterModel>? centers,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return CentersState(
      status: status ?? this.status,
      centers: centers ?? this.centers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, centers, hasReachedMax, currentPage, errorMessage];
}
