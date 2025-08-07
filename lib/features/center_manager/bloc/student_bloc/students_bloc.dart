import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final CenterManagerRepository centerManagerRepository;
  StudentsBloc({required this.centerManagerRepository})
    : super(const StudentsState()) {
    on<FetchStudents>(_onFetchStudents);
    on<FetchMoreStudents>(_onFetchMoreStudents);
    on<ApplyStudentsFilter>(_onApplyStudentsFilter); // تسجيل الحدث الجديد
    on<DeleteStudent>(_onDeleteStudent);
     on<UpdateStudentInList>(_onUpdateStudentInList);
  }
  // دالة جديدة للتعامل مع الفلترة
  Future<void> _onApplyStudentsFilter(
    ApplyStudentsFilter event,
    Emitter<StudentsState> emit,
  ) async {
    // حفظ الفلاتر المطبقة في الحالة ثم استدعاء دالة الجلب الرئيسية
    emit(
      state.copyWith(
        halaqaIdFilter: event.halaqaId,
        levelIdFilter: event.levelId,
      ),
    );
    add(
      const FetchStudents(),
    ); // استدعاء FetchStudents سيعيد استخدام الفلاتر المحفوظة
  }

  // دالة جديدة للتعامل مع الحذف
  Future<void> _onDeleteStudent(
    DeleteStudent event,
    Emitter<StudentsState> emit,
  ) async {
    final result = await centerManagerRepository.deleteStudent(event.studentId);
    result.fold(
      (failure) {
        /* يمكنك إرسال حالة خطأ هنا */
        add(const FetchStudents());
      },
      (_) {
        // عند النجاح، قم بإزالة الطالب من القائمة الحالية في الواجهة فوراً
        final updatedStudents = List<Student>.from(state.students)
          ..removeWhere((student) => student.id == event.studentId);
        emit(state.copyWith(students: updatedStudents));
      },
    );
  }

  Future<void> _onFetchStudents(
    FetchStudents event,
    Emitter<StudentsState> emit,
  ) async {
    emit(state.copyWith(status: StudentsStatus.loading));
    final result = await centerManagerRepository.getStudents(
      page: 1,
      searchQuery: event.searchQuery,
      halaqaId: state.halaqaIdFilter, // استخدام الفلتر من الحالة
      levelId: state.levelIdFilter,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StudentsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) {
        final List<dynamic> studentListJson = data['data'];
        final students =
            studentListJson.map((json) => Student.fromJson(json)).toList();
        emit(
          state.copyWith(
            status: StudentsStatus.success,
            students: students,
            currentPage: 1,
            hasReachedMax: data['next_page_url'] == null,
          ),
        );
      },
    );
  }

  Future<void> _onFetchMoreStudents(
    FetchMoreStudents event,
    Emitter<StudentsState> emit,
  ) async {
    if (state.hasReachedMax) return; // لا تقم بأي طلب إذا وصلنا للنهاية

    final nextPage = state.currentPage + 1;
    final result = await centerManagerRepository.getStudents(page: nextPage);

    result.fold(
      (failure) {
        /* يمكنك التعامل مع الخطأ هنا إذا أردت */
      },
      (data) {
        final List<dynamic> studentListJson = data['data'];
        final newStudents =
            studentListJson.map((json) => Student.fromJson(json)).toList();
        emit(
          state.copyWith(
            status: StudentsStatus.success,
            students: List.of(state.students)..addAll(newStudents),
            currentPage: nextPage,
            hasReachedMax: data['next_page_url'] == null,
          ),
        );
      },
    );
  }

   // دالة لتحديث طالب واحد في القائمة بعد تعديله أو نقله
  void _onUpdateStudentInList(UpdateStudentInList event, Emitter<StudentsState> emit) {
      final updatedList = state.students.map((student) {
          if (student.id == event.updatedStudent.id) {
              return event.updatedStudent;
          }
          return student;
      }).toList();
      emit(state.copyWith(students: updatedList));
  }
}
