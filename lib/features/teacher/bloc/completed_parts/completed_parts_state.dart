part of 'completed_parts_bloc.dart';

enum PartsStatus { initial, loading, success, failure, submitting }

class CompletedPartsState extends Equatable {
  final PartsStatus status;
  final List<Map<String, dynamic>> parts;
  final String? errorMessage;
  final String? successMessage; // أضف هذا السطر

  const CompletedPartsState({
    this.status = PartsStatus.initial,
    this.parts = const [],
    this.errorMessage,
    this.successMessage, // أضف هذا السطر
  });

  CompletedPartsState copyWith({
    PartsStatus? status,
    List<Map<String, dynamic>>? parts,
    String? errorMessage,
    String? successMessage, // أضف هذا السطر
  }) {
    return CompletedPartsState(
      status: status ?? this.status,
      parts: parts ?? this.parts,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage, // أضف هذا السطر (لا تستخدم ?? هنا لتمكين مسح الرسالة)
    );
  }

  @override
  List<Object?> get props => [status, parts, errorMessage, successMessage]; // أضف successMessage هنا
}
