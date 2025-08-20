part of 'mosques_bloc.dart';

enum MosquesStatus { initial, loading, success, failure }

class MosquesState extends Equatable {
  final MosquesStatus status;
  final List<Mosque> mosques;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;
  final String? successMessage;

  const MosquesState({
    this.status = MosquesStatus.initial,
    this.mosques = const <Mosque>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
    this.successMessage,
  });

  MosquesState copyWith({
    MosquesStatus? status,
    List<Mosque>? mosques,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return MosquesState(
      status: status ?? this.status,
      mosques: mosques ?? this.mosques,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, mosques, hasReachedMax, currentPage, errorMessage, successMessage];
}
