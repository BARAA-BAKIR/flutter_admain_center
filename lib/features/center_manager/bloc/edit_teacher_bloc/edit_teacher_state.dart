// lib/features/center_manager/bloc/edit_teacher_bloc/edit_teacher_state.dart

part of 'edit_teacher_bloc.dart'; // <-- الخطوة 1: الربط بالملف الرئيسي للـ BLoC

// استخدام enum لتحديد الحالات بشكل واضح ومنظم
enum EditTeacherStatus { initial, loading, success, failure, submitting }

class EditTeacherState extends Equatable {
  final EditTeacherStatus status;
  final TeacherDetailsModel? initialData; // البيانات الأصلية التي يتم عرضها
  final String? errorMessage;

  const EditTeacherState({
    this.status = EditTeacherStatus.initial,
    this.initialData,
    this.errorMessage,
  });

  // دالة مساعدة لإنشاء نسخة جديدة من الحالة بسهولة
  EditTeacherState copyWith({
    EditTeacherStatus? status,
    TeacherDetailsModel? initialData,
    String? errorMessage,
  }) {
    return EditTeacherState(
      status: status ?? this.status,
      initialData: initialData ?? this.initialData,
      errorMessage: errorMessage, // السماح بإعادة تعيين الخطأ إلى null
    );
  }

  @override
  List<Object?> get props => [status, initialData, errorMessage];
}
