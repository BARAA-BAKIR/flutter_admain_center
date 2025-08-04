// lib/features/teacher/bloc/halaqa_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // استيراد ضروري للتاريخ
import 'package:flutter_admain_center/data/models/daily_follow_up_model.dart'; // استيراد مودل المتابعة
import 'package:flutter_admain_center/data/models/duty_model.dart'; // استيراد مودل الواجب
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/data/models/myhalaqa_model.dart';
import 'package:flutter_admain_center/data/models/student_model.dart';

part 'halaqa_event.dart';
part 'halaqa_state.dart';

class HalaqaBloc extends Bloc<HalaqaEvent, HalaqaState> {
  final TeacherRepository _teacherRepository;

  HalaqaBloc({required TeacherRepository teacherRepository})
      : _teacherRepository = teacherRepository,
        super(const HalaqaState()) {
          
    on<FetchHalaqaData>(_onFetchHalaqaData);
    on<MarkStudentAttendance>(_onMarkStudentAttendance); // سنقوم بتعديل هذا المعالج
  }

  Future<void> _onFetchHalaqaData(FetchHalaqaData event, Emitter<HalaqaState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // هذه الدالة الآن تجلب البيانات من السيرفر أو الكاش وتدمجها مع المتابعات المحلية
      final halaqaData = await _teacherRepository.getMyHalaqaWithLocalData();
      emit(state.copyWith(isLoading: false, halaqa: halaqaData ,
        error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // =================================================================
  // --- هذا هو الجزء الذي تم تعديله بالكامل ---
  // =================================================================
  Future<void> _onMarkStudentAttendance(MarkStudentAttendance event, Emitter<HalaqaState> emit) async {
    if (state.halaqa == null) return;

    // 1. تحديث الواجهة فوراً لتعطي شعوراً بالاستجابة الفورية
    final updatedStudents = List<Student>.from(state.halaqa!.students);
    final studentIndex = updatedStudents.indexWhere((s) => s.id == event.studentId);

    if (studentIndex != -1) {
      updatedStudents[studentIndex] = updatedStudents[studentIndex].copyWith(
        attendanceStatus: event.newStatus,
      );
      emit(state.copyWith(
        halaqa: state.halaqa!.copyWith(students: updatedStudents),
      ));
    }

    // 2. إنشاء سجل متابعة كامل في الخلفية
    try {
      // جلب أي بيانات متابعة أو واجب موجودة مسبقاً لهذا الطالب اليوم
      final existingData = await _teacherRepository.getFollowUpAndDutyForStudent(
        event.studentId,
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      final DailyFollowUpModel? existingFollowUp = existingData['followUp'];
      final DutyModel? existingDuty = existingData['duty'];

      // إنشاء مودل المتابعة مع الحفاظ على البيانات القديمة إن وجدت
      final followUpToSave = DailyFollowUpModel(
        studentId: event.studentId,
        halaqaId: state.halaqa!.idhalaqa,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        attendance: event.newStatus == AttendanceStatus.present ? 1 : 0, 
        // نحافظ على القيم القديمة إذا كانت موجودة، وإلا نستخدم القيم الافتراضية
        savedPagesCount: existingFollowUp?.savedPagesCount ?? 0,
        reviewedPagesCount: existingFollowUp?.reviewedPagesCount ?? 0,
        memorizationScore: existingFollowUp?.memorizationScore ?? 4, // ممتاز
        reviewScore: existingFollowUp?.reviewScore ?? 4, // ممتاز
      );

      // إنشاء مودل الواجب مع الحفاظ على البيانات القديمة إن وجدت
      final dutyToSave = DutyModel(
        studentId: event.studentId,
        startPage: existingDuty?.startPage ?? 0,
        endPage: existingDuty?.endPage ?? 0,
        requiredParts: existingDuty?.requiredParts ?? '',
      );

      // 3. حفظ السجل في الـ Repository (الذي سيقوم بحفظه محلياً أو مزامنته)
      await _teacherRepository.storeFollowUpAndDuty(followUpToSave, dutyToSave);
      
      print("✅ تم حفظ الحضور محلياً للطالب: ${event.studentId}");

    } catch (e) {
      // إذا حدث خطأ أثناء الحفظ في الخلفية، يمكننا إظهاره
      // لكن لا نوقف عمل التطبيق
      print("Error saving attendance in background: $e");
      // يمكنك هنا إرسال حدث جديد للبلوك لإظهار رسالة خطأ إذا أردت
      // emit(state.copyWith(error: "فشل حفظ الحضور في الخلفية"));
    }
  }
  // =================================================================
}
