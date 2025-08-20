import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'teachers_event.dart';
part 'teachers_state.dart';

class TeachersBloc extends Bloc<TeachersEvent, TeachersState> {
  final CenterManagerRepository centerManagerRepository;

  TeachersBloc({required this.centerManagerRepository}) : super(const TeachersState()) {
    on<FetchTeachers>(_onFetchTeachers);
    on<FetchMoreTeachers>(_onFetchMoreTeachers);
     on<DeleteTeacher>(_onDeleteTeacher);
      on<AddNewTeacherToList>(_onAddNewTeacherToList);
       on<UpdateTeacherInList>(_onUpdateTeacherInList);
  }
void _onUpdateTeacherInList(UpdateTeacherInList event, Emitter<TeachersState> emit) {
    // 1. أنشئ نسخة من القائمة الحالية
    final currentState = state;
    final List<Teacher> updatedList = List.from(currentState.teachers);

    // 2. ابحث عن index الأستاذ الذي تم تعديله
    final index = updatedList.indexWhere((teacher) => teacher.id == event.updatedTeacher.id);

    // 3. إذا تم العثور عليه، استبدله بالبيانات الجديدة
    if (index != -1) {
      updatedList[index] = event.updatedTeacher;
      // 4. أرسل الحالة الجديدة مع القائمة المحدثة
      emit(currentState.copyWith(teachers: updatedList));
    }
  }
  Future<void> _onFetchTeachers(FetchTeachers event, Emitter<TeachersState> emit) async {
    emit(state.copyWith(status: TeachersStatus.loading));
    final result = await centerManagerRepository.getTeachers(page: 1, searchQuery: event.searchQuery);
    
    result.fold(
      (failure) => emit(state.copyWith(status: TeachersStatus.failure, errorMessage: failure.message)),
      (data) {
        final List<dynamic> listJson = data['data'];
        final items = listJson.map((json) => Teacher.fromJson(json)).toList();
        emit(state.copyWith(
          status: TeachersStatus.success,
          teachers: items,
          currentPage: 1,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onFetchMoreTeachers(FetchMoreTeachers event, Emitter<TeachersState> emit) async {
    if (state.hasReachedMax) return;

    final nextPage = state.currentPage + 1;
    final result = await centerManagerRepository.getTeachers(page: nextPage);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (data) {
        final List<dynamic> listJson = data['data'];
        final newItems = listJson.map((json) => Teacher.fromJson(json)).toList();
        emit(state.copyWith(
          status: TeachersStatus.success,
          teachers: List.of(state.teachers)..addAll(newItems),
          currentPage: nextPage,
          hasReachedMax: data['next_page_url'] == null,
        ));
      },
    );
  }
   Future<void> _onDeleteTeacher(DeleteTeacher event, Emitter<TeachersState> emit) async {
    // يمكنك عرض حالة تحميل مؤقتة إذا أردت
    
    final result = await centerManagerRepository.deleteTeacher(event.teacherId);

    result.fold(
      (failure) {
        // في حالة الفشل، يمكنك إرسال حالة خطأ لعرض SnackBar
        emit(state.copyWith(errorMessage: failure.message));
      },
      (_) {
        // في حالة النجاح، قم بإزالة الأستاذ من القائمة الحالية في الواجهة فوراً
        final updatedList = List<Teacher>.from(state.teachers)
          ..removeWhere((teacher) => teacher.id == event.teacherId);
        
        emit(state.copyWith(teachers: updatedList));
      },
    );
  }
  void _onAddNewTeacherToList(AddNewTeacherToList event, Emitter<TeachersState> emit) {
    // إنشاء قائمة جديدة تحتوي على الأستاذ الجديد في البداية، ثم باقي الأساتذة
    final updatedList = [event.newTeacher, ...state.teachers];
    
    // إصدار حالة جديدة مع القائمة المحدثة ورسالة نجاح
    emit(state.copyWith(
      teachers: updatedList,
      successMessage: 'تمت إضافة الأستاذ بنجاح إلى القائمة.',
    ));
  }
}
