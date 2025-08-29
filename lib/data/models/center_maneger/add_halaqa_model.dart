// lib/data/models/center_manager/add_halaqa_model.dart
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';

class AddHalaqaModel extends Equatable {
  final String name;
  final int masjidId;
  final int halaqaTypeId; // ✅ التصحيح: أصبح مطلوباً
  final int? teacherId;   // الأستاذ لا يزال اختيارياً
final String? workingDays;
  final String? startDate;
final String? endDate;
  const AddHalaqaModel({
    required this.name,
    required this.masjidId,
    required this.halaqaTypeId,
    this.teacherId,
    this.workingDays,
    this.startDate,
    this.endDate
  });

  Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = {
      'name': name,
      'mosque_id': masjidId,
      'type': halaqaTypeId,
    };

    // ==================== هنا هو الإصلاح النهائي ====================
    // لا تقم بإضافة أي من حقول الأستاذ إذا لم يتم تحديد أستاذ
    if (teacherId != null) {
      data['teacher_id'] = teacherId;
      data['working_days'] = workingDays;
      data['start_date'] = startDate;
      
      // أرسل تاريخ النهاية فقط إذا كان موجوداً وغير فارغ
      if (endDate != null && endDate!.isNotEmpty) {
        data['end_date'] = endDate;
      }
    }
    // =============================================================

    return data;
  }

  @override
  List<Object?> get props => [name, masjidId, halaqaTypeId, teacherId, workingDays, startDate,endDate];
}