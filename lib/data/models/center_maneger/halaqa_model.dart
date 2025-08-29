
class Halaqa {
  final int id;
  final String name;
  final String? description;
  final int studentCount;
  final String? teacherName;
  final String? mosqueName;

  const Halaqa({
    required this.id,
    required this.name,
    this.description,
    required this.studentCount,
    this.teacherName,
    this.mosqueName,
  });

  factory Halaqa.fromJson(Map<String, dynamic> json) {
    String? teacherFullName;
    if (json['halaqa_progress'] != null && (json['halaqa_progress'] as List).isNotEmpty) {
      final teacherData = json['halaqa_progress'][0]?['teacher']?['employee'];
      if (teacherData != null) {
        final firstName = teacherData['first_name'] ?? '';
        final lastName = teacherData['last_name'] ?? '';
        teacherFullName = '$firstName $lastName'.trim();
      }
    }

    return Halaqa(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'اسم غير معروف',
      description: json['description'],
      studentCount: json['student_progress_count'] ?? 0,
      mosqueName: json['mosque']?['name'],
      teacherName: teacherFullName,
    );
  }
}
