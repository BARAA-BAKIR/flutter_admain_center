int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

class DashboardModel {
  final DashboardSummary summary;
  final List<NeedsAttentionStudent> needsAttention;
  final List<TopStudent> topStudents;
  final AttendanceChartData attendanceChart;

  DashboardModel({
    required this.summary,
    required this.needsAttention,
    required this.topStudents,
    required this.attendanceChart,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      summary: DashboardSummary.fromJson(json['summary'] ?? {}),
      needsAttention: (json['needs_attention'] as List? ?? [])
          .map((i) => NeedsAttentionStudent.fromJson(i))
          .toList(),
      topStudents: (json['top_students'] as List? ?? [])
          .map((i) => TopStudent.fromJson(i))
          .toList(),
      attendanceChart: AttendanceChartData.fromJson(json['attendance_chart'] ?? {}),
    );
  }
}

class DashboardSummary {
  final int presentToday;
  final int absentToday;
  final int evaluatedToday;

  DashboardSummary({
    required this.presentToday,
    required this.absentToday,
    required this.evaluatedToday,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      presentToday: _parseInt(json['present_today']),
      absentToday: _parseInt(json['absent_today']),
      evaluatedToday: _parseInt(json['evaluated_today']),
    );
  }
}

class NeedsAttentionStudent {
  final int id;
  final String name;
  final String lastEvaluation;

  NeedsAttentionStudent({
    required this.id,
    required this.name,
    required this.lastEvaluation,
  });

  factory NeedsAttentionStudent.fromJson(Map<String, dynamic> json) {
    final String fullName = "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}".trim();

    final followUp = (json['student_tracking'] as List?)?.firstOrNull;
    final String evaluationText = followUp != null
        ? 'حفظ: ${followUp['memorization_score']}, مراجعة: ${followUp['review_score']}'
        : 'لا يوجد تقييم';

    return NeedsAttentionStudent(
      id: _parseInt(json['id']),
      name: fullName,
      lastEvaluation: evaluationText,
    );
  }
}

class TopStudent {
  final int id;
  final String name;

  TopStudent({
    required this.id,
    required this.name,
  });

  factory TopStudent.fromJson(Map<String, dynamic> json) {
    final studentData = json['student'] ?? {};
    final String fullName = "${studentData['first_name'] ?? ''} ${studentData['last_name'] ?? ''}".trim();
    return TopStudent(
      id: _parseInt(json['student_id']),
      name: fullName,
    );
  }
}

class AttendanceChartData {
  final int present;
  final int absent;

  AttendanceChartData({
    required this.present,
    required this.absent,
  });

  factory AttendanceChartData.fromJson(Map<String, dynamic> json) {
    return AttendanceChartData(
      present: _parseInt(json['present']),
      absent: _parseInt(json['absent']),
    );
  }
}
