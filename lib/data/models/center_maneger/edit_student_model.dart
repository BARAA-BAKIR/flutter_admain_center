// لا حاجة لـ fromJson في هذا المودل، لأننا نستخدمه فقط للإرسال (toJson)
// وهذا يبسط الكود أكثر!
class EditStudentModel {
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String birthDate;
  final String gender;
  final String socialStatus;
  final String educationaLevel;
  final String? healthStatus;
  final String contactNumber;
  final int halaqaId;
  final int levelId;

  EditStudentModel({
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.gender,
    required this.socialStatus,
    required this.educationaLevel,
    this.healthStatus,
    required this.contactNumber,
    required this.halaqaId,
    required this.levelId,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'father_name': fatherName,
      'mother_name': motherName,
      'birth_date': birthDate,
      'gender': gender,
      'social_status': socialStatus,
      'educationa_level': educationaLevel,
      'health_status': healthStatus,
      'contact_number': contactNumber,
      'halaqa_id': halaqaId,
      'level_id': levelId,
    };
  }
}
