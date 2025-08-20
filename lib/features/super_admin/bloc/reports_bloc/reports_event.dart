// features/super_admin/bloc/reports_bloc/reports_event.dart
part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
  @override
  List<Object?> get props => [];
}

// Event to generate the student report
class GenerateStudentReport extends ReportsEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  const GenerateStudentReport({this.startDate, this.endDate});
}

// Event to generate the attendance report
class GenerateAttendanceReport extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final int? centerId;
  const GenerateAttendanceReport({required this.startDate, required this.endDate, this.centerId});
}

// Event to generate the teacher report
class GenerateTeacherReport extends ReportsEvent {}

// Event to load data needed for filters (like the list of centers)
class LoadReportFilters extends ReportsEvent {}
