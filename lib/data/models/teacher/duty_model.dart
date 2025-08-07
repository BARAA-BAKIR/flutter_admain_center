// lib/data/models/duty_model.dart

class DutyModel {
  final int studentId;
  final int startPage;
  final int endPage;
  final String requiredParts;
  bool isSynced;

  DutyModel({
    required this.studentId,
    required this.startPage,
    required this.endPage,
    required this.requiredParts,
    this.isSynced = false,
  });
  DutyModel copyWith({
    int? studentId,
    int? startPage,
    int? endPage,
    String? requiredParts,
    bool? isSynced,
  }) {
    return DutyModel(
      studentId: studentId ?? this.studentId,
      startPage: startPage ?? this.startPage,
      endPage: endPage ?? this.endPage,
      requiredParts: requiredParts ?? this.requiredParts,
      isSynced: isSynced ?? this.isSynced,
    );
  }
  // دالة لتحويل النموذج إلى JSON لإرساله إلى API لارافل
  Map<String, dynamic> toJsonForApi() {
    return {
      'student_id': studentId,
      'start_page': startPage,
      'end_page': endPage,
      'requred_parts': requiredParts,
    };
  }

  // دالة لتحويل النموذج إلى JSON لحفظه في قاعدة البيانات المحلية (Sembast)
  Map<String, dynamic> toSembastJson() {
    final data = toJsonForApi();
    data['isSynced'] = isSynced;
    return data;
  }
   // دالة لإنشاء كائن من بيانات Sembast
  factory DutyModel.fromSembast(Map<String, dynamic> json) {
    return DutyModel(
      studentId: json['student_id'] ?? 0,
      startPage: json['start_page'] ?? 0,
      endPage: json['end_page']?? 0,
      requiredParts: json['requred_parts'] ?? '',
      isSynced: json['isSynced'] ?? false,
    );
  }
  // fromjson factory method
  factory DutyModel.fromJson(Map<String, dynamic> json) {
    return DutyModel(
      studentId: json['student_id'] ?? 0,
      startPage: json['start_page'] ?? 0,
      endPage: json['end_page'] ?? 0,
      requiredParts: json['requred_parts'] ?? '',
      //isSynced: json['isSynced'] ?? false,
    );
  }
}

