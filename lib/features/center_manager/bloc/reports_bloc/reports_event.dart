// part of 'reports_bloc.dart';

// abstract class ReportsEvent extends Equatable {
//   const ReportsEvent();
//   @override
//   List<Object> get props => [];
// }

// class GenerateStudentsReport extends ReportsEvent {}
// class GenerateAttendanceReport extends ReportsEvent {
//   final DateTime startDate;
//   final DateTime endDate;
//   final int? halaqaId;

//   const GenerateAttendanceReport({required this.startDate, required this.endDate, this.halaqaId});
// }
part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
  @override
  List<Object?> get props => [];
}

// حدث لتقرير الطلاب
class GenerateStudentsListReport extends ReportsEvent {}

// حدث لتقرير الأساتذة
class GenerateTeachersListReport extends ReportsEvent {}

// حدث لتقرير الحضور (معدل قليلاً)
class GenerateAttendanceReport extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final int? halaqaId;

  const GenerateAttendanceReport({
    required this.startDate,
    required this.endDate,
    this.halaqaId,
  });

  @override
  List<Object?> get props => [startDate, endDate, halaqaId];
}
