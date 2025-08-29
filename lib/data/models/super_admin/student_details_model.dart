// في ملف: lib/data/models/super_admin/student_details_model.dart

class StudentDetails {
  final int id;
  final String? name; // اسم المستخدم قد يكون null إذا فشل الربط
  final String? email;
  
  // --- ✅  التعديلات الرئيسية هنا ---
  // اجعل كل الحقول التي قد تكون null قابلة للـ null باستخدام '?'
  final String? firstName;
  final String? lastName;
  final String? fatherName;
  final String? motherName;
  final String? birthDate;
  final String? gender;
  final String? contactNumber;
  final String? educationLevel;
  final String? healthStatus;
  final String? socialStatus;
  final int? maleSiblingsCount;
  final int? femaleSiblingsCount;
  final bool? isOneParentDeceased;

  final int? centerId;
  final int? halaqaId;
  final int? levelId;

  StudentDetails({
    required this.id,
    this.name,
    this.email,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.motherName,
    this.birthDate,
    this.gender,
    this.contactNumber,
    this.educationLevel,
    this.healthStatus,
    this.socialStatus,
    this.maleSiblingsCount,
    this.femaleSiblingsCount,
    this.isOneParentDeceased,
    this.centerId,
    this.halaqaId,
    this.levelId,
  });

  factory StudentDetails.fromJson(Map<String, dynamic> json) {
    return StudentDetails(
      id: json['id'],
      name: json['user']?['name'],
      email: json['user']?['email'],
      
      // --- ✅  لا تغيير هنا، Dart سيتعامل مع null تلقائيًا ---
      // بما أن المتغيرات أصبحت قابلة للـ null، يمكنها استقبال قيم null من الـ JSON بأمان
      firstName: json['first_name'],
      lastName: json['last_name'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      contactNumber: json['contact_number'],
      educationLevel: json['education_level'],
      healthStatus: json['health_status'],
      socialStatus: json['social_status'],
      
      // التعامل مع الأرقام التي قد تكون null
      maleSiblingsCount: json['male_siblings_count'],
      femaleSiblingsCount: json['female_siblings_count'],
      
      // التعامل مع القيم المنطقية (boolean)
      isOneParentDeceased: json['is_one_parent_deceased'] == 1 || json['is_one_parent_deceased'] == true,
      
      centerId: json['center_id'],
      halaqaId: json['halaqa_id'],
      levelId: json['level_id'],
    );
  }
}
