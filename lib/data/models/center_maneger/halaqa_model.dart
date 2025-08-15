import 'package:equatable/equatable.dart';

class Halaqa extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? teacherName;
  final String? mosqueName;
  final int studentCount;
  const Halaqa({
    required this.id,
    required this.name,
    this.description,
    this.teacherName,
    this.mosqueName,
     this.studentCount = 0,
  });
 factory Halaqa.fromJson(Map<String, dynamic> json) {
    String? teacherFullName;
    
    // ==================== هنا هو الإصلاح الكامل والنهائي ====================
    // 1. اقرأ 'halaqa_progress' كقائمة
    final progressList = json['halaqa_progress'] as List<dynamic>?;

    // 2. تحقق من أن القائمة ليست فارغة
    if (progressList != null && progressList.isNotEmpty) {
      // 3. خذ أول عنصر في القائمة (لأنه يمثل آخر مشرف)
      final progressData = progressList.first as Map<String, dynamic>?;
      
      if (progressData != null && progressData['teacher'] != null) {
        final teacherData = progressData['teacher'];
        if (teacherData['employee'] != null) {
          final firstName = teacherData['employee']['first_name'] ?? '';
          final lastName = teacherData['employee']['last_name'] ?? '';
          teacherFullName = '$firstName $lastName'.trim();
        }
      }
    }
    // ====================================================================

    return Halaqa(
      id: json['id'],
      name: json['name'] ?? 'اسم غير محدد',
        studentCount: json['students_count'] ?? 0,
      description: json['description'],
      teacherName: teacherFullName, //  الآن سيحصل على القيمة الصحيحة
      mosqueName: json['mosque'] != null ? json['mosque']['name'] : null,
    );
  }

  @override
  List<Object?> get props => [id, name, description, teacherName, mosqueName,studentCount];
}
