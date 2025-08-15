import 'package:equatable/equatable.dart';

class StudentListItem extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String? halaqaName;

  const StudentListItem({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.halaqaName,
  });

  String get fullName => '$firstName $lastName';

  factory StudentListItem.fromJson(Map<String, dynamic> json) {
    return StudentListItem(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      halaqaName: json['halaqa_name'],
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, halaqaName];
}
