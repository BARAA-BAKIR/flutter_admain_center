// lib/features/center_manager/bloc/teachers_bloc/teachers_event.dart

part of 'teachers_bloc.dart';

abstract class TeachersEvent extends Equatable {
  const TeachersEvent();
  @override
  List<Object?> get props => [];
}

// لجلب الدفعة الأولى من الأساتذة أو للبحث
class FetchTeachers extends TeachersEvent {
  final String? searchQuery;
  const FetchTeachers({this.searchQuery});
}

// لجلب المزيد من الأساتذة عند التمرير
class FetchMoreTeachers extends TeachersEvent {}

// لحذف أستاذ
class DeleteTeacher extends TeachersEvent {
  final int teacherId;
  const DeleteTeacher(this.teacherId);

  @override
  List<Object> get props => [teacherId];
}

// ✅✅✅  الإضافة الجديدة والمهمة  ✅✅✅
// لتحديث بيانات أستاذ واحد في القائمة بعد العودة من شاشة التعديل
class UpdateTeacherInList extends TeachersEvent {
  final Teacher updatedTeacher;
  const UpdateTeacherInList(this.updatedTeacher);

  @override
  List<Object?> get props => [updatedTeacher];
}

// لإضافة أستاذ جديد إلى القائمة بعد العودة من شاشة الإضافة
class AddNewTeacherToList extends TeachersEvent {
  final Teacher newTeacher;
  const AddNewTeacherToList(this.newTeacher);

  @override
  List<Object?> get props => [newTeacher];
}
