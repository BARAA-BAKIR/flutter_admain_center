import 'package:equatable/equatable.dart';

class DashboardSummaryCenter extends Equatable {
  final int studentCount;
  final int teacherCount;
  final int halaqaCount;
  final int pendingRequests;
  final double presentPercentage;
  final double absentPercentage;

  const DashboardSummaryCenter({
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
      studentCount: json['student_count'] ?? 0,
      teacherCount: json['teacher_count'] ?? 0,
      halaqaCount: json['halaqa_count'] ?? 0,
      pendingRequests: json['pending_requests'] ?? 0,
      presentPercentage: (attendance['present'] as num).toDouble(),
      absentPercentage: (attendance['absent'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [studentCount, teacherCount, halaqaCount, pendingRequests, presentPercentage, absentPercentage];
}
