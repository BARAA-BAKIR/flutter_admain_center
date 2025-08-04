// // lib/data/models/daily_follow_up_model.dart
// import 'package:flutter_admain_center/data/models/student_model.dart';

// class DailyFollowUpModel {
//   final int studentId;
//   final int groupId;
//   final String date; // YYYY-MM-DD

//   // الحفظ والمراجعة
//   final int savedPagesCount;
//   final int reviewedPagesCount;
//   final int memorizationScore;
//   final int reviewScore;

//   // --- الحقول الجديدة للواجب ---
//   final int dutyFromPage;
//   final int dutyToPage;
//   final String dutyRequiredParts; // نص للأجزاء مثل "عم، تبارك"

//   // الحالة
//   final AttendanceStatus attendanceStatus;
//   bool isSynced;

//   DailyFollowUpModel({
//     required this.studentId,
//     required this.groupId,
//     required this.date,
//     this.savedPagesCount = 0,
//     this.reviewedPagesCount = 0,
//     this.memorizationScore = 0,
//     this.reviewScore = 0,
//     this.dutyFromPage = 0, // قيمة افتراضية
//     this.dutyToPage = 0,   // قيمة افتراضية
//     this.dutyRequiredParts = '', // قيمة افتراضية
//     this.attendanceStatus = AttendanceStatus.present,
//     this.isSynced = false,
//   });

//   // ... (باقي الدوال: copyWith, toJson, fromSembast)
//   // تأكد من تحديثها لتشمل الحقول الجديدة

//   Map<String, dynamic> toJson() {
//     return {
//       'studentId': studentId,
//       'groupId': groupId,
//       'date': date,
//       'savedPagesCount': savedPagesCount,
//       'reviewedPagesCount': reviewedPagesCount,
//       'memorizationScore': memorizationScore,
//       'reviewScore': reviewScore,
//       'dutyFromPage': dutyFromPage,
//       'dutyToPage': dutyToPage,
//       'dutyRequiredParts': dutyRequiredParts,
//       'attendanceStatus': attendanceStatus.name, // .name لتحويل الـ enum إلى نص
//       'isSynced': isSynced,
//     };
//   }

//   factory DailyFollowUpModel.fromSembast(Map<String, dynamic> json) {
//     return DailyFollowUpModel(
//       studentId: json['studentId'],
//       groupId: json['groupId'],
//       date: json['date'],
//       savedPagesCount: json['savedPagesCount'] ?? 0,
//       reviewedPagesCount: json['reviewedPagesCount'] ?? 0,
//       memorizationScore: json['memorizationScore'] ?? 0,
//       reviewScore: json['reviewScore'] ?? 0,
//       dutyFromPage: json['dutyFromPage'] ?? 0,
//       dutyToPage: json['dutyToPage'] ?? 0,
//       dutyRequiredParts: json['dutyRequiredParts'] ?? '',
//       attendanceStatus: AttendanceStatus.values.firstWhere(
//         (e) => e.name == json['attendanceStatus'],
//         orElse: () => AttendanceStatus.present,
//       ),
//       isSynced: json['isSynced'] ?? false,
//     );
//   }

//   DailyFollowUpModel copyWith({
//     int? studentId,
//     int? groupId,
//     String? date,
//     int? savedPagesCount,
//     int? reviewedPagesCount,
//     int? memorizationScore,
//     int? reviewScore,
//     int? dutyFromPage,
//     int? dutyToPage,
//     String? dutyRequiredParts,
//     AttendanceStatus? attendanceStatus,
//     bool? isSynced,
//   }) {
//     return DailyFollowUpModel(
//       studentId: studentId ?? this.studentId,
//       groupId: groupId ?? this.groupId,
//       date: date ?? this.date,
//       savedPagesCount: savedPagesCount ?? this.savedPagesCount,
//       reviewedPagesCount: reviewedPagesCount ?? this.reviewedPagesCount,
//       memorizationScore: memorizationScore ?? this.memorizationScore,
//       reviewScore: reviewScore ?? this.reviewScore,
//       dutyFromPage: dutyFromPage ?? this.dutyFromPage,
//       dutyToPage: dutyToPage ?? this.dutyToPage,
//       dutyRequiredParts: dutyRequiredParts ?? this.dutyRequiredParts,
//       attendanceStatus: attendanceStatus ?? this.attendanceStatus,
//       isSynced: isSynced ?? this.isSynced,
//     );
//   }
// }
 