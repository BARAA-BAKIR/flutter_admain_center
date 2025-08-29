part of 'mosques_bloc.dart';

enum MosquesStatus { initial, loading, success, failure }

class MosquesState extends Equatable {
  final MosquesStatus status;
  final List<MosqueModel> mosques;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;

  const MosquesState({
    this.status = MosquesStatus.initial,
    this.mosques = const <MosqueModel>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  MosquesState copyWith({
    MosquesStatus? status,
    List<MosqueModel>? mosques,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return MosquesState(
      status: status ?? this.status,
      mosques: mosques ?? this.mosques,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, mosques, hasReachedMax, currentPage, errorMessage];
}
