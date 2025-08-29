import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// استيراد الموديلات الصحيحة
import 'package:flutter_admain_center/data/models/center_maneger/student_details_model.dart';

import 'package:flutter_admain_center/data/models/center_maneger/student_list_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final CenterManagerRepository centerManagerRepository;
  StudentsBloc({required this.centerManagerRepository}) : super(const StudentsState()) {
    on<FetchStudents>(_onFetchStudents);
    on<FetchMoreStudents>(_onFetchMoreStudents);
    on<ApplyStudentsFilter>(_onApplyStudentsFilter);
    on<DeleteStudent>(_onDeleteStudent);
    on<UpdateStudentInList>(_onUpdateStudentInList);
  }

  Future<void> _onFetchStudents(FetchStudents event, Emitter<StudentsState> emit) async {
    emit(state.copyWith(status: StudentsStatus.loading));
    final result = await centerManagerRepository.getStudents(
      page: 1,
      searchQuery: event.searchQuery,
      halaqaId: state.halaqaIdFilter,
      levelId: state.levelIdFilter,
    );

    result.fold(
      (failure) => emit(state.copyWith(status: StudentsStatus.failure, errorMessage: failure.message)),
      (data) {
        final List<dynamic> studentListJson = data['data'];
        final students = studentListJson.map((json) => StudentListItem.fromJson(json)).toList();
        emit(state.copyWith(
          status: StudentsStatus.success,
          students: students,
          currentPage: 1,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onFetchMoreStudents(FetchMoreStudents event, Emitter<StudentsState> emit) async {
    if (state.hasReachedMax) return;
    final nextPage = state.currentPage + 1;
    final result = await centerManagerRepository.getStudents(page: nextPage, halaqaId: state.halaqaIdFilter, levelId: state.levelIdFilter);

    result.fold(
      (failure) {},
      (data) {
        final List<dynamic> studentListJson = data['data'];
        final newStudents = studentListJson.map((json) => StudentListItem.fromJson(json)).toList();
        emit(state.copyWith(
          status: StudentsStatus.success,
          students: List.of(state.students)..addAll(newStudents),
          currentPage: nextPage,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }

  // ==================== هنا هو التصحيح النهائي ====================
  void _onUpdateStudentInList(UpdateStudentInList event, Emitter<StudentsState> emit) {
    final updatedList = state.students.map((studentInList) {
      // إذا كان ID الطالب في القائمة يطابق ID الطالب المحدث
      if (studentInList.id == event.updatedStudent.id) {
        // قم بإنشاء كائن جديد من نوع StudentListItem (المودل الخفيف)
        // باستخدام البيانات من المودل الشامل (event.updatedStudent)
        return StudentListItem(
          id: event.updatedStudent.id,
          firstName: event.updatedStudent.firstName,
          lastName: event.updatedStudent.lastName,
          halaqaName: event.updatedStudent.halaqan?.name, // الوصول الآمن لاسم الحلقة
        );
      }
      // إذا لم يكن هو الطالب المطلوب، أرجعه كما هو
      return studentInList;
    }).toList();
    // أرسل القائمة المحدثة إلى الحالة
    emit(state.copyWith(students: updatedList));
  }
  // =============================================================

  Future<void> _onDeleteStudent(DeleteStudent event, Emitter<StudentsState> emit) async {
    final result = await centerManagerRepository.deleteStudent(event.studentId);
    result.fold(
      (failure) {},
      (_) {
        final updatedStudents = List<StudentListItem>.from(state.students)
          ..removeWhere((student) => student.id == event.studentId);
        emit(state.copyWith(students: updatedStudents));
      },
    );
  }

  Future<void> _onApplyStudentsFilter(ApplyStudentsFilter event, Emitter<StudentsState> emit) async {
    emit(state.copyWith(halaqaIdFilter: event.halaqaId, levelIdFilter: event.levelId));
    add(const FetchStudents());
  }
}
