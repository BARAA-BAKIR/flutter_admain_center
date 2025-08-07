part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
  @override
  List<Object> get props => [];
}

class GenerateStudentsReport extends ReportsEvent {}
class GenerateAttendanceReport extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final int? halaqaId;

  const GenerateAttendanceReport({required this.startDate, required this.endDate, this.halaqaId});
}