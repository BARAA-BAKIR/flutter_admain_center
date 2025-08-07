// lib/data/models/add_student_model.dart

class AddStudentModel {
  // --- بيانات جدول users ---
  final String username; // اسم المستخدم (مثلاً رقم الهاتف)
  final String password;
  final String email ; 
  // --- بيانات جدول students ---
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String birthDate; // YYYY-MM-DD
  final String gender;
  final String phone;
  // ignore: non_constant_identifier_names
  final String social_status;
  final String educationaLevel;
  final String healthStatus;
  //final bool is_one_parent_deceased;
  final int male_siblings_count;
  final int female_siblings_count;
  
  final int halaqaId; // ID الحلقة التي سينضم إليها الطالب
  final int levelId; // ID المرحلة التعليمية
  AddStudentModel({
    required this.username,
    required this.password,
    required this.email, // Laravel يتوقع 'email' في نموذج المستخدم
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.gender,
    required this.phone,
    required this.social_status,
    required this.educationaLevel,
    required this.healthStatus,
    required this.female_siblings_count,
  //  required this.is_one_parent_deceased,
    required this.male_siblings_count,
    required this.halaqaId, 
    required this.levelId,
  });

  Map<String, dynamic> toJson() {
    return {
      // User data
      'name': username, // Laravel يتوقع 'name'
      'password': password,
      'email': email, 

      // Student data
      'first_name': firstName,
      'last_name': lastName,
      'father_name': fatherName,
      'mother_name': motherName,
      'birth_date': birthDate,
      'gender': gender,
      'contact_number': phone,
      
      'education_level': educationaLevel,
      'health_status': healthStatus,
      'status':'مستمر',
      'social_status': social_status, 

      // 'is_one_parent_deceased':null,
      'female_siblings_count':female_siblings_count,
      'male_siblings_count':male_siblings_count,
      'halaqa_id': halaqaId,
      'level_id': levelId, // ID المرحلة التعليمية
    };
  }
}
