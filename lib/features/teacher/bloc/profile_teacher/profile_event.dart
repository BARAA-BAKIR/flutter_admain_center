// In lib/features/teacher/bloc/profile_teacher/profile_event.dart

part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}
class VerifyPasswordForEdit extends ProfileEvent {
  final String password;

  const VerifyPasswordForEdit(this.password);

  @override
  List<Object> get props => [password];
}
class FetchProfileData extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String? fatherName;
  final String? motherName;
  final DateTime? birthDate;
  final String? educationLevel;
  final String gender;
  final String phoneNumber;
  final String? address;
  final String currentPassword;
  final String? newPassword;
  final String? newPasswordConfirmation;

  const UpdateProfile({
    required this.firstName,
    required this.lastName,
    this.fatherName,
    this.motherName,
    this.birthDate,
    this.educationLevel,
    required this.gender,
    required this.phoneNumber,
    this.address,
    required this.currentPassword,
    this.newPassword,
    this.newPasswordConfirmation,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        fatherName,
        motherName,
        birthDate,
        educationLevel,
        gender,
        phoneNumber,
        address,
        currentPassword,
        newPassword,
        newPasswordConfirmation,
      ];
}
