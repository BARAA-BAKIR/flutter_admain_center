// features/super_admin/bloc/reports_bloc/reports_bloc.dart
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
    on<GenerateStudentReport>(_onGenerateStudentReport);
    on<GenerateAttendanceReport>(_onGenerateAttendanceReport);
    on<GenerateTeacherReport>(_onGenerateTeacherReport);
    on<LoadReportFilters>(_onLoadReportFilters);
  }

  Future<void> _onGenerateStudentReport(GenerateStudentReport event, Emitter<ReportsState> emit) async {
    emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير الطلاب...'));
    final result = await _superAdminRepository.getStudentReport(startDate: event.startDate, endDate: event.endDate);
    result.fold(
      (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(status: ReportStatus.success, reportData: data)),
    );
  }

  Future<void> _onGenerateAttendanceReport(GenerateAttendanceReport event, Emitter<ReportsState> emit) async {
    emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير الحضور...'));
    final result = await _superAdminRepository.getAttendanceReport(startDate: event.startDate, endDate: event.endDate, centerId: event.centerId);
    result.fold(
      (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(status: ReportStatus.success, reportData: data)),
    );
  }

  Future<void> _onGenerateTeacherReport(GenerateTeacherReport event, Emitter<ReportsState> emit) async {
    emit(state.copyWith(status: ReportStatus.loading, loadingMessage: 'جاري إنشاء تقرير الأساتذة...'));
    final result = await _superAdminRepository.getTeacherReport();
    result.fold(
      (failure) => emit(state.copyWith(status: ReportStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(status: ReportStatus.success, reportData: data)),
    );
  }

  Future<void> _onLoadReportFilters(LoadReportFilters event, Emitter<ReportsState> emit) async {
    // No need to show loading for this, it can happen in the background
    final result = await _superAdminRepository.getCentersList();
    result.fold(
      (failure) { /* Handle error silently or log it */ },
      (centersData) => emit(state.copyWith(centers: centersData)),
    );
  }
}
