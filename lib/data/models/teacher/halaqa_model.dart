// lib/data/models/halaqa_model.dart

class HalaqaModel {
  // final int id;
  final String name;
  final String mosqueName;
  final int studentCount;
  final String timings;
  final String description;

  HalaqaModel({
    // required this.id,
    required this.name,
    required this.mosqueName,
    required this.studentCount,
    required this.timings,
    required this.description,
  });

  // دالة لإنشاء كائن من النموذج من خلال JSON القادم من الـ API
  factory HalaqaModel.fromJson(Map<String, dynamic> json) {
    // **هنا التعديل**
    // التأكد من أن كل مفتاح موجود وإلا سيتم إرجاع قيمة افتراضية
    return HalaqaModel(
      // id: json['id'] ?? 0,
      name: json['halaqa_name'] as String? ?? 'غير متوفر',
      mosqueName: json['mosque_name'] as String? ?? 'غير متوفر',
      studentCount: json['count_students'] as int? ?? 0,
      timings: json['days'] as String? ?? 'غير محدد',
      description: json['type'] as String? ?? 'لا يوجد وصف',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      //  'id': id,
      'name': name,
      'mosque_name': mosqueName,
      'count_students': studentCount,
      'days': timings,
      'type': description,
    };
  }
}