import 'package:equatable/equatable.dart';

class DashboardSummaryCenter extends Equatable {
  final String name_center;
  final int studentCount;
  final int teacherCount;
  final int halaqaCount;
  final int pendingRequests;
  final double presentPercentage;
  final double absentPercentage;

  const DashboardSummaryCenter({
    required this.name_center,
    required this.studentCount,
    required this.teacherCount,
    required this.halaqaCount,
    required this.pendingRequests,
    required this.presentPercentage,
    required this.absentPercentage,
  });

  factory DashboardSummaryCenter.fromJson(Map<String, dynamic> json) {
    final attendance = json['attendance_summary'] ?? {'present': 0, 'absent': 0};
    return DashboardSummaryCenter(
      name_center: json['name_center']??'',
      studentCount: json['student_count'] ?? 0,
      teacherCount: json['teacher_count'] ?? 0,
      halaqaCount: json['halaqa_count'] ?? 0,
      pendingRequests: json['pending_requests'] ?? 0,
      presentPercentage: (attendance['present'] as num?)?.toDouble()??0.0,
      absentPercentage: (attendance['absent'] as num?)?.toDouble()?? 0.0,
    );
  }

  @override
  List<Object?> get props => [name_center,studentCount, teacherCount, halaqaCount, pendingRequests, presentPercentage, absentPercentage];
}
