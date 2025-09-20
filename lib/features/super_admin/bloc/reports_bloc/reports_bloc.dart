// // In features/super_admin/bloc/reports_bloc/reports_bloc.dart

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

// part 'reports_event.dart';
// part 'reports_state.dart';

// class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
//   final SuperAdminRepository _superAdminRepository;

//   ReportsBloc({required SuperAdminRepository superAdminRepository})
//       : _superAdminRepository = superAdminRepository,
//         super(const ReportsState()) {
//     // --- ✅✅ بداية التعديلات ✅✅ ---
//     on<GenerateComprehensiveStudentReport>(_onGenerateComprehensiveStudentReport);
//     on<GenerateTeacherProductivityReport>(_onGenerateTeacherProductivityReport);
//     on<GenerateGeneralAttendanceReport>(_onGenerateGeneralAttendanceReport);
//     on<LoadReportFilters>(_onLoadReportFilters);
//     // --- ✅✅ نهاية التعديلات ✅✅ ---
//   }

//   Future<void> _onGenerateComprehensiveStudentReport(
//       GenerateComprehensiveStudentReport event, Emitter<ReportsState> emit) async {
//     emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير أداء الطلاب...'));
//     // استدعاء الدالة الجديدة من الريبو
//     final result = await _superAdminRepository.getComprehensiveStudentReport(
//       startDate: event.startDate,
//       endDate: event.endDate,
//       centerId: event.centerId,
//       halaqaId: event.halaqaId,
//     );
//     result.fold(
//       (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
//       (data) => emit(state.copyWith(
//         status: ReportStatus.success,
//         reportData: data,
//         reportTitle: 'تقرير أداء الطلاب الشامل', // تحديد عنوان التقرير
//       )),
//     );
//   }

//   Future<void> _onGenerateTeacherProductivityReport(
//       GenerateTeacherProductivityReport event, Emitter<ReportsState> emit) async {
//     emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير إنجاز الأساتذة...'));
//     // استدعاء الدالة الجديدة من الريبو
//     final result = await _superAdminRepository.getTeacherProductivityReport(
//       startDate: event.startDate,
//       endDate: event.endDate,
//       centerId: event.centerId,
//     );
//     result.fold(
//       (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
//       (data) => emit(state.copyWith(
//         status: ReportStatus.success,
//         reportData: data,
//         reportTitle: 'تقرير إنجاز الأساتذة والحلقات', // تحديد عنوان التقرير
//       )),
//     );
//   }

//   Future<void> _onGenerateGeneralAttendanceReport(
//       GenerateGeneralAttendanceReport event, Emitter<ReportsState> emit) async {
//     emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير الحضور العام...'));
//     // استدعاء الدالة الجديدة من الريبو
//     final result = await _superAdminRepository.getGeneralAttendanceReport(
//       startDate: event.startDate,
//       endDate: event.endDate,
//       centerId: event.centerId,
//     );
//     result.fold(
//       (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
//       (data) => emit(state.copyWith(
//         status: ReportStatus.success,
//         reportData: data,
//         reportTitle: 'تقرير الحضور والالتزام العام', // تحديد عنوان التقرير
//       )),
//     );
//   }

//   Future<void> _onLoadReportFilters(LoadReportFilters event, Emitter<ReportsState> emit) async {
//     final result = await _superAdminRepository.getCentersList();
//     result.fold(
//       (failure) { /* Handle error silently or log it */ },
//       (centersData) => emit(state.copyWith(centers: centersData)),
//     );
//   }
// }
// في ملف reports_bloc.dart


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final SuperAdminRepository _superAdminRepository;

  ReportsBloc({required SuperAdminRepository superAdminRepository})
      : _superAdminRepository = superAdminRepository,
        super(const ReportsState()) {
    on<GenerateComprehensiveStudentReport>(_onGenerateComprehensiveStudentReport);
    on<GenerateTeacherProductivityReport>(_onGenerateTeacherProductivityReport);
    on<GenerateGeneralAttendanceReport>(_onGenerateGeneralAttendanceReport);
    on<LoadReportFilters>(_onLoadReportFilters);
  }

  Future<void> _onGenerateComprehensiveStudentReport(
      GenerateComprehensiveStudentReport event, Emitter<ReportsState> emit) async {
    emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير أداء الطلاب...'));
    
    final result = await _superAdminRepository.getComprehensiveStudentReport(
      startDate: event.startDate,
      endDate: event.endDate,
      centerId: event.centerId,
      // halaqaId: event.halaqaId,
    );
    
    result.fold(
      (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(
        status: ReportStatus.success,
        reportData: data,
        reportTitle: 'تقرير أداء الطلاب الشامل',
      )),
    );
  }

  Future<void> _onGenerateTeacherProductivityReport(
      GenerateTeacherProductivityReport event, Emitter<ReportsState> emit) async {
    emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير إنجاز الأساتذة...'));
    
    final result = await _superAdminRepository.getTeacherProductivityReport(
      startDate: event.startDate,
      endDate: event.endDate,
      centerId: event.centerId,
    );
    
    result.fold(
      (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(
        status: ReportStatus.success,
        reportData: data,
        reportTitle: 'تقرير إنجاز الأساتذة',
      )),
    );
  }

  Future<void> _onGenerateGeneralAttendanceReport(
      GenerateGeneralAttendanceReport event, Emitter<ReportsState> emit) async {
    emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير الحضور العام...'));
    
    final result = await _superAdminRepository.getGeneralAttendanceReport(
      startDate: event.startDate,
      endDate: event.endDate,
      centerId: event.centerId,
    );
    
    result.fold(
      (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(
        status: ReportStatus.success,
        reportData: data,
        reportTitle: 'تقرير الحضور العام',
      )),
    );
  }

  Future<void> _onLoadReportFilters(LoadReportFilters event, Emitter<ReportsState> emit) async {
    final result = await _superAdminRepository.getCentersList();
    result.fold(
      (failure) { /* Handle error silently or log it */ },
      (centersData) => emit(state.copyWith(centers: centersData)),
    );
  }
}