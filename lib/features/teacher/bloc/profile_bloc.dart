import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/data/models/student_profile_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

// استيراد ملفات الحدث والحالة
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final TeacherRepository _teacherRepository;

  ProfileBloc({required TeacherRepository teacherRepository})
      : _teacherRepository = teacherRepository,
        super(const ProfileState()) { // الحالة الأولية
    
    // تسجيل معالج الحدث
    on<FetchProfileData>(_onFetchProfileData);
  }

  // هذه هي الدالة التي يتم استدعاؤها عند وصول حدث FetchProfileData
  Future<void> _onFetchProfileData(
    FetchProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    // 1. نصدر حالة التحميل أولاً لعرض مؤشر التحميل في الواجهة
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      // 2. نستدعي دالة الـ Repository لجلب البيانات
      final profileData = await _teacherRepository.getStudentProfile(event.studentId);
      
      // 3. إذا نجحنا، نصدر حالة النجاح مع البيانات التي تم جلبها
      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: profileData,
      ));
    } catch (e) {
      // 4. إذا فشلنا، نصدر حالة الفشل مع رسالة الخطأ
      emit(state.copyWith(
        status: ProfileStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
