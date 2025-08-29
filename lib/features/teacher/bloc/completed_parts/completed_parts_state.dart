// In lib/features/teacher/bloc/completed_parts/completed_parts_state.dart
part of 'completed_parts_bloc.dart';

enum PartsStatus { initial, loading, success, failure, submitting }

class CompletedPartsState extends Equatable {
  final PartsStatus status;
  final List<Map<String, dynamic>> parts;
  final String? errorMessage;

  const CompletedPartsState({
    this.status = PartsStatus.initial,
    this.parts = const [],
    this.errorMessage,
  });

  CompletedPartsState copyWith({
    PartsStatus? status,
    List<Map<String, dynamic>>? parts,
    String? errorMessage,
  }) {
    return CompletedPartsState(
      status: status ?? this.status,
      parts: parts ?? this.parts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, parts, errorMessage];
}
