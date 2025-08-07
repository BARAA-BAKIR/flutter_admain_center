class TeacherProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String birthDate;
  final String educationLevel;
  final String startDate;
  final String phoneNumber;
  final String address;
  final String email;

  TeacherProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.educationLevel,
    required this.startDate,
    required this.phoneNumber,
    required this.address,
    required this.email,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      id: json['id'],
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      fatherName: json['father_name'] as String? ?? '',
      motherName: json['mother_name'] as String? ?? '',
      birthDate: json['birth_date'] as String? ?? '',
      educationLevel: json['education_level'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      address: json['address'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}