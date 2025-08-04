// lib/data/models/daily_follow_up_model.dart

class DailyFollowUpModel {
  final int studentId;
  final int halaqaId;
  final String date; // صيغة "YYYY-MM-DD"
  final int savedPagesCount;
  final int reviewedPagesCount;
  final int memorizationScore; // رقم من 0 إلى 5
  final int reviewScore;       // رقم من 0 إلى 5
  final int attendance;
  bool isSynced;

  DailyFollowUpModel({
    required this.studentId,
    required this.halaqaId,
    required this.date,
    required this.savedPagesCount,
    required this.reviewedPagesCount,
    required this.memorizationScore,
    required this.reviewScore,
    required this.attendance,
    this.isSynced = false,
  });

  // دالة لتحويل النموذج إلى JSON لإرساله إلى API لارافل
  Map<String, dynamic> toJsonForApi() {
    return {
      'student_id': studentId,
      'group_id': halaqaId,
      'date': date,
      'saved_pages_count': savedPagesCount,
      'reviewed_pages_count': reviewedPagesCount,
      'memorization_score': memorizationScore,
      'review_score': reviewScore,
      'attendance': attendance,
    };
  }
    // دالة لتحويل النموذج إلى JSON لحفظه في قاعدة البيانات المحلية (Sembast)
  Map<String, dynamic> toSembastJson() {
    final data = toJsonForApi();
    data['isSynced'] = isSynced;
    return data;
  }
   factory DailyFollowUpModel.fromSembast(Map<String, dynamic> json) {
    return DailyFollowUpModel(
      // **هذا هو التحصين الذي سيحل المشكلة**
      // إذا كانت أي قيمة رقمية null في قاعدة البيانات المحلية، نستخدم 0 كقيمة افتراضية.
      studentId: json['student_id'] ?? 0,
      halaqaId: json['group_id'] ?? 0,
      
      date: json['date'] ?? '',
      savedPagesCount: json['saved_pages_count'] ?? 0,
      reviewedPagesCount: json['reviewed_pages_count'] ?? 0,
      memorizationScore: json['memorization_score'] ?? 0,
      reviewScore: json['review_score'] ?? 0,
      
      // بالنسبة للقيم المنطقية، نتحقق من أنها ليست null، وإلا نستخدم false
      attendance: json['attendance'] ?? 0,
      isSynced: json['isSynced'] ?? false,
    );
  }
  
  //from json
  factory DailyFollowUpModel.fromJson(Map<String, dynamic> json) {
    return DailyFollowUpModel(
      studentId: json['student_id'] ?? 0,
      halaqaId: json['group_id'] ?? 0,
      date: json['date'] ?? '',
      savedPagesCount: json['saved_pages_count'] ?? 0,
      reviewedPagesCount: json['reviewed_pages_count'] ?? 0,
      memorizationScore: json['memorization_score'] ?? 0,
      reviewScore: json['review_score'] ?? 0,
      attendance: json['attendance'] ?? 0,
     // isSynced: false, // القيمة الافتراضية
    );
  }
}
  