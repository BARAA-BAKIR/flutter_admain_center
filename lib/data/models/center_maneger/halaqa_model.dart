import 'package:equatable/equatable.dart';

class Halaqa extends Equatable {
  final int id;
  final String name;
  final String? masjidName;
  final String? teacherName;

  const Halaqa({
    required this.id,
    required this.name,
    this.masjidName,
    this.teacherName,
  });

  factory Halaqa.fromJson(Map<String, dynamic> json) {
    // استخراج اسم الأستاذ بشكل آمن
    String? teacherFullName;
    if (json['teacher'] != null && json['teacher']['employee'] != null) {
      teacherFullName = '${json['teacher']['employee']['first_name']} ${json['teacher']['employee']['last_name']}';
    }

    return Halaqa(
      id: json['id'],
      name: json['name'] ?? 'اسم غير متوفر',
      masjidName: json['masjid'] != null ? json['masjid']['name'] : 'مسجد غير محدد',
      teacherName: teacherFullName ?? 'غير معين',
    );
  }

  @override
  List<Object?> get props => [id, name, masjidName, teacherName];
}
