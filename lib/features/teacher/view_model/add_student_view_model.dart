import 'package:flutter/widgets.dart';

class AddStudentViewModel {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final socialstatusController = TextEditingController();
  final passwordController = TextEditingController();
  final educationalLevelController = TextEditingController();
  final healthStatusController = TextEditingController();
  final maleSiblingsController = TextEditingController();
  final femaleSiblingsController = TextEditingController();

  void disposeControllers() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    socialstatusController.dispose();
    passwordController.dispose();
    educationalLevelController.dispose();
    healthStatusController.dispose();
    maleSiblingsController.dispose();
    femaleSiblingsController.dispose();
  }
}
