// class Student {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String? phone;
//   final String? halaqaName; // <-- تغيير هنا: لم يعد كائن، بل اسم مباشر

//   Student({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     this.phone,
//     this.halaqaName, // <-- تغيير هنا
//   });

//   String get fullName => '$firstName $lastName';

//   factory Student.fromJson(Map<String, dynamic> json) {
//     return Student(
//       id: json['id'],
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//       phone: json['contact_number'], // تأكد من أن الاسم يطابق اسم العمود
//       halaqaName: json['halaqa_name'], // <-- قراءة الاسم المستعار مباشرة
//     );
//   }
// }
