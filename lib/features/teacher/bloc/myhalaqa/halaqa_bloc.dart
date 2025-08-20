// lib/features/teacher/bloc/halaqa_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/features/teacher/bloc/dashboard/dashboard_bloc.dart';
//import 'package:intl/intl.dart';
// Import failures
//import 'package:flutter_admain_center/data/models/teacher/daily_follow_up_model.dart';
//import 'package:flutter_admain_center/data/models/teacher/duty_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/data/models/teacher/myhalaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/student_model.dart';

part 'halaqa_event.dart';
part 'halaqa_state.dart';

class HalaqaBloc extends Bloc<HalaqaEvent, HalaqaState> {
  final TeacherRepository _teacherRepository;
  final DashboardBloc _dashboardBloc;
  HalaqaBloc({
    required TeacherRepository teacherRepository,
    required DashboardBloc dashboardBloc,
  }) : _teacherRepository = teacherRepository,
       _dashboardBloc = dashboardBloc,
       super(const HalaqaState()) {
    on<FetchHalaqaData>(_onFetchHalaqaData);
    on<MarkStudentAttendance>(_onMarkStudentAttendance);
  }

  Future<void> _onFetchHalaqaData(
    FetchHalaqaData event,
    Emitter<HalaqaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, noHalaqaAssigned: false));

    // Use fold() to handle the result from the repository
    final result = await _teacherRepository.getMyHalaqaWithLocalData();
    result.fold(
      // Failure case (Left)
      (failure) {
        if (failure is ServerFailure) {
          // 2. إذا كان كذلك، يمكنك الآن الوصول إلى statusCode بأمان
          if (failure.statusCode == 404) {
            // هذا يعني أن الأستاذ ليس لديه حلقة
            emit(state.copyWith(isLoading: false, noHalaqaAssigned: true));
          } else {
            // أي خطأ آخر من الخادم
            emit(state.copyWith(isLoading: false, error: failure.message));
          }
        } else {
          // 3. إذا كان الفشل من نوع آخر (مثل CacheFailure)، تعامل معه هنا
          emit(state.copyWith(isLoading: false, error: failure.message));
        }
      },
      // Success case (Right)
      (halaqaData) {
        emit(
          state.copyWith(
            isLoading: false,
            halaqa: halaqaData,
            error: null,
            noHalaqaAssigned: false,
          ),
        );
        if (halaqaData.idhalaqa != 0) {
          _dashboardBloc.add(LoadDashboardData(halaqaId: halaqaData.idhalaqa));
        }
      },
    );
  }

  Future<void> _onMarkStudentAttendance(
    MarkStudentAttendance event,
    Emitter<HalaqaState> emit,
  ) async {
    if (state.halaqa == null) return;

    // تحديث الواجهة فوراً (لتحسين تجربة المستخدم)
    final updatedStudents =
        state.halaqa!.students.map((s) {
          if (s.id == event.studentId) {
            return s.copyWith(attendanceStatus: event.newStatus);
          }
          return s;
        }).toList();
    emit(
      state.copyWith(halaqa: state.halaqa!.copyWith(students: updatedStudents)),
    );

    // ====================  هنا هو الإصلاح ====================
    // استدعاء الدالة الجديدة في الـ Repository
    await _teacherRepository.markAttendanceOnly(
      event.studentId,
      state.halaqa!.idhalaqa,
      event.newStatus == AttendanceStatus.present,
    );

    // بعد تسجيل الحضور، يجب أن نعيد تحميل البيانات لتعكس التغييرات
    // هذا يضمن أن hasTodayFollowUp تصبح true
    add(FetchHalaqaData());
    // if (state.halaqa == null) return;

    // // 1. Update the UI instantly for a responsive feel
    // final updatedStudents = List<Student>.from(state.halaqa!.students);
    // final studentIndex = updatedStudents.indexWhere((s) => s.id == event.studentId);

    // if (studentIndex != -1) {
    //   updatedStudents[studentIndex] = updatedStudents[studentIndex].copyWith(
    //     attendanceStatus: event.newStatus,
    //   );
    //   emit(state.copyWith(
    //     halaqa: state.halaqa!.copyWith(students: updatedStudents),
    //   ));
    // }

    // // 2. Create a complete follow-up record in the background
    // // Use fold() to handle the result from the repository
    // final existingDataResult = await _teacherRepository.getFollowUpAndDutyForStudent(
    //   event.studentId,
    //   DateFormat('yyyy-MM-dd').format(DateTime.now()),
    // );

    // existingDataResult.fold(
    //   // Failure case for getting existing data (e.g., connection failure)
    //   (failure) {
    //     print("Error getting existing data for attendance: ${failure.message}");
    //     // You can emit a new state with an error message here if needed.
    //   },
    //   // Success case for getting existing data
    //   (existingData) async {
    //     final DailyFollowUpModel? existingFollowUp = existingData['followUp'];
    //     final DutyModel? existingDuty = existingData['duty'];

    //     final followUpToSave = DailyFollowUpModel(
    //       studentId: event.studentId,
    //       halaqaId: state.halaqa!.idhalaqa,
    //       date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    //       attendance: event.newStatus == AttendanceStatus.present ? 1 : 0,
    //       savedPagesCount: existingFollowUp?.savedPagesCount ?? 0,
    //       reviewedPagesCount: existingFollowUp?.reviewedPagesCount ?? 0,
    //       memorizationScore: existingFollowUp?.memorizationScore ?? 4,
    //       reviewScore: existingFollowUp?.reviewScore ?? 4,
    //     );

    //     final dutyToSave = DutyModel(
    //       studentId: event.studentId,
    //       startPage: existingDuty?.startPage ?? 0,
    //       endPage: existingDuty?.endPage ?? 0,
    //       requiredParts: existingDuty?.requiredParts ?? '',
    //     );

    //     // 3. Save the record using the repository and handle the result with fold()
    //     final storeResult = await _teacherRepository.storeFollowUpAndDuty(followUpToSave, dutyToSave);

    //     storeResult.fold(
    //       // Failure case for storing data
    //       (failure) {
    //         print("Error saving attendance in background: ${failure.message}");
    //         // You can emit a state to show an error here
    //       },
    //       // Success case for storing data
    //       (isSynced) {
    //         print("✅ Attendance saved successfully for student: ${event.studentId}. Synced: $isSynced");
    //         // You can emit a state to show a success message here
    //       },
    //     );
    //   },
    // );
  }
}
