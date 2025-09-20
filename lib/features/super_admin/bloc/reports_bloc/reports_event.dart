// // In features/super_admin/bloc/reports_bloc/reports_event.dart

// part of 'reports_bloc.dart';

// abstract class ReportsEvent extends Equatable {
//   const ReportsEvent();

//   @override
//   List<Object?> get props => [];
// }

// // --- ✅✅ بداية التعديلات ✅✅ ---

// // 1. حدث جديد لتقرير أداء الطلاب الشامل
// class GenerateComprehensiveStudentReport extends ReportsEvent {
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final int? centerId;
//   final int? halaqaId; // فلتر اختياري إضافي

//   const GenerateComprehensiveStudentReport({
//     this.startDate,
//     this.endDate,
//     this.centerId,
//     this.halaqaId,
//   });

//   @override
//   List<Object?> get props => [startDate, endDate, centerId, halaqaId];
// }

// // 2. حدث جديد لتقرير إنجاز الأساتذة
// class GenerateTeacherProductivityReport extends ReportsEvent {
//   final DateTime startDate;
//   final DateTime endDate;
//   final int? centerId;

//   const GenerateTeacherProductivityReport({
//     required this.startDate,
//     required this.endDate,
//     this.centerId,
//   });

//   @override
//   List<Object?> get props => [startDate, endDate, centerId];
// }

// // 3. حدث جديد لتقرير الحضور العام (نستخدم نفس الحدث القديم مع اسم أوضح)
// class GenerateGeneralAttendanceReport extends ReportsEvent {
//   final DateTime startDate;
//   final DateTime endDate;
//   final int? centerId;

//   const GenerateGeneralAttendanceReport({
//     required this.startDate,
//     required this.endDate,
//     this.centerId,
//   });

//   @override
//   List<Object?> get props => [startDate, endDate, centerId];
// }

// // 4. هذا الحدث يبقى كما هو لجلب بيانات الفلاتر
// class LoadReportFilters extends ReportsEvent {}

part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

// حدث تقرير أداء الطلاب الشامل (التواريخ اختيارية)
class GenerateComprehensiveStudentReport extends ReportsEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? centerId;

  const GenerateComprehensiveStudentReport({
    this.startDate,
    this.endDate,
    this.centerId,
  });

  @override
  List<Object?> get props => [startDate, endDate, centerId];
}

// حدث تقرير إنجاز الأساتذة (التواريخ مطلوبة)
class GenerateTeacherProductivityReport extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final int? centerId;

  const GenerateTeacherProductivityReport({
    required this.startDate,
    required this.endDate,
    this.centerId,
  });

  @override
  List<Object?> get props => [startDate, endDate, centerId];
}

// حدث تقرير الحضور العام (التواريخ مطلوبة)
class GenerateGeneralAttendanceReport extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final int? centerId;

  const GenerateGeneralAttendanceReport({
    required this.startDate,
    required this.endDate,
    this.centerId,
  });

  @override
  List<Object?> get props => [startDate, endDate, centerId];
}

// حدث تحميل فلاتر التقارير
class LoadReportFilters extends ReportsEvent {}

