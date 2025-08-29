part of 'add_edit_mosque_bloc.dart';

// استخدام enum لتحسين قراءة الحالة
enum FormStatus { initial, loading, loaded, submitting, success, failure }

class AddEditMosqueState extends Equatable {
  final FormStatus status;
  final MosqueModel? initialData;
  final List<CenterModel> availableCenters; // ✅ 1. إضافة قائمة المراكز هنا
  final String? errorMessage;

  const AddEditMosqueState({
    this.status = FormStatus.initial,
    this.initialData,
    this.availableCenters = const [], // ✅ 2. القيمة الافتراضية هي قائمة فارغة
    this.errorMessage,
  });

  AddEditMosqueState copyWith({
    FormStatus? status,
    MosqueModel? initialData,
    List<CenterModel>? availableCenters, // ✅ 3. إضافة الـ copyWith
    String? errorMessage,
  }) {
    return AddEditMosqueState(
      status: status ?? this.status,
      initialData: initialData ?? this.initialData,
      availableCenters: availableCenters ?? this.availableCenters,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, initialData, availableCenters, errorMessage];
}
