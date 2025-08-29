// lib/features/teacher/view/add_student_screen.dart

import 'package:flutter/material.dart';
// تأكد من وجود هذا النموذج
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/features/teacher/view_model/add_student_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/features/teacher/bloc/add_student/add_student_bloc.dart';
import 'package:intl/intl.dart';

// هذه الويدجت الآن لا تنشئ الـ Bloc، بل تستهلكه فقط
class AddStudentScreen extends StatefulWidget {
  final int halaqaId;

  const AddStudentScreen({super.key, this.halaqaId = 0});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  late AddStudentViewModel viewModel;
  // --- Controllers لإدارة إدخالات المستخدم ---
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _socialstatusController = TextEditingController();
  final _passwordController = TextEditingController();
  final _educationalLevelController = TextEditingController();
  final _healthStatusController = TextEditingController();
  final _maleSiblingsController = TextEditingController();
  final _femaleSiblingsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = AddStudentViewModel();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _socialstatusController.dispose();
    _passwordController.dispose();
    _educationalLevelController.dispose();
    _healthStatusController.dispose();
    _maleSiblingsController.dispose();
    _femaleSiblingsController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    final isStep1Valid = _formKeyStep1.currentState?.validate() ?? false;
    final isStep2Valid = _formKeyStep2.currentState?.validate() ?? false;

    if (isStep1Valid && isStep2Valid) {
      final currentState = context.read<AddStudentBloc>().state;
      if (currentState.selectedLevelId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء اختيار مرحلة الطالب')),
        );
        return;
      }
      final studentData = AddStudentModel(
        username: _firstNameController.text,
        email: _emailController.text, // استخدام البريد الإلكتروني,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        fatherName: _fatherNameController.text,
        motherName: _motherNameController.text,
        birthDate: _birthDateController.text,
        gender: currentState.gender,
        phone: _phoneController.text,
        social_status: currentState.social_status,
        // address: _addressController.text,
        educationaLevel: _educationalLevelController.text,
        healthStatus: _healthStatusController.text,
        halaqaId: widget.halaqaId, // استخدام الـ ID الذي تم تمريره
        levelId: currentState.selectedLevelId!,
        female_siblings_count:
            int.tryParse(_femaleSiblingsController.text) ?? 0,
        male_siblings_count: int.tryParse(_maleSiblingsController.text) ?? 0,
      );
      context.read<AddStudentBloc>().add(SubmitStudentData(studentData));
    }
  }

  @override
  Widget build(BuildContext context) {
    // لا يوجد BlocProvider هنا
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إضافة طالب جديد',
          style: GoogleFonts.tajawal(color: Colors.white),
        ),
        backgroundColor: AppColors.steel_blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<AddStudentBloc, AddStudentState>(
        listener: (context, state) {
          if (state.saveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('تمت إضافة الطالب بنجاح'),
                backgroundColor: Colors.green, // --- هذا هو الإصلاح ---
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(
                  bottom: 50.0, // ارفع الـ SnackBar فوق الزر العائم
                  left: 16.0,
                  right: 16.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            );
            Navigator.of(context).pop();
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red, // --- هذا هو الإصلاح ---
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(
                  bottom: 50.0, // ارفع الـ SnackBar فوق الزر العائم
                  left: 16.0,
                  right: 16.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stepper(
            currentStep: state.currentStep,
            onStepTapped:
                (step) => context.read<AddStudentBloc>().add(StepChanged(step)),
            onStepContinue: () {
              final isLastStep =
                  state.currentStep == _buildSteps(context, state).length - 1;
              if (isLastStep) {
                _submitForm(context);
              } else {
                context.read<AddStudentBloc>().add(
                  StepChanged(state.currentStep + 1),
                );
              }
            },
            onStepCancel: () {
              if (state.currentStep > 0) {
                context.read<AddStudentBloc>().add(
                  StepChanged(state.currentStep - 1),
                );
              }
            },
            steps: _buildSteps(context, state),
            controlsBuilder: (context, details) {
              return state.isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (details.currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('السابق'),
                          ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(
                            details.currentStep ==
                                    _buildSteps(context, state).length - 1
                                ? 'إضافة الطالب'
                                : 'التالي',
                          ),
                        ),
                      ],
                    ),
                  );
            },
          );
        },
      ),
    );
  }

  List<Step> _buildSteps(BuildContext context, AddStudentState state) {
    return [
      Step(
        title: const Text('المعلومات الشخصية'),
        isActive: state.currentStep >= 0,
        content: Form(
          key: _formKeyStep1,
          child: Column(
            children: [
              CustomTextField(
                controller: _firstNameController,
                labelText: 'الاسم الأول',
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'الكنية',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _fatherNameController,
                labelText: 'اسم الأب',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _motherNameController,
                labelText: 'اسم الأم',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              //email
              CustomTextField(
                controller: _emailController,
                labelText: 'البريد الإلكتروني',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _birthDateController,
                labelText: 'تاريخ الميلاد',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _birthDateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(date);
                  }
                },
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('الجنس:', style: GoogleFonts.tajawal(fontSize: 16)),
                    Radio<String>(
                      value: 'ذكر',
                      groupValue: state.gender,
                      onChanged:
                          (v) => context.read<AddStudentBloc>().add(
                            GenderChanged(v!),
                          ),
                    ),
                    Text('ذكر', style: GoogleFonts.tajawal()),
                    Radio<String>(
                      value: 'أنثى',
                      groupValue: state.gender,
                      onChanged:
                          (v) => context.read<AddStudentBloc>().add(
                            GenderChanged(v!),
                          ),
                    ),
                    Text('أنثى', style: GoogleFonts.tajawal()),
                  ],

                  // --- هذا هو الإصلاح ---
                  //الحالة الاجتماعية متزوج او اعزب وافترا
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'الحالة الاجتماعية:',
                      style: GoogleFonts.tajawal(fontSize: 16),
                    ),
                    Radio<String>(
                      value: 'اعزب',
                      groupValue: state.social_status,
                      onChanged:
                          (v) => context.read<AddStudentBloc>().add(
                            SocialStatusChanged(v!),
                          ),
                    ),
                    Text('اعزب', style: GoogleFonts.tajawal()),
                    Radio<String>(
                      value: 'متزوج',
                      groupValue: state.social_status,
                      onChanged:
                          (v) => context.read<AddStudentBloc>().add(
                            SocialStatusChanged(v!),
                          ),
                    ),
                    Text('متزوج', style: GoogleFonts.tajawal()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('معلومات إضافية وحساب'),
        isActive: state.currentStep >= 1,
        content: Form(
          key: _formKeyStep2,
          child: Column(
            children: [
              CustomTextField(
                controller: _phoneController,
                labelText: 'رقم الهاتف (سيكون اسم المستخدم)',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'كلمة المرور للطالب',
                icon: Icons.lock,
                isPassword: true,
                validator:
                    (v) => v!.length < 6 ? 'كلمة المرور قصيرة جداً' : null,
              ),

              CustomTextField(
                controller: _educationalLevelController,
                labelText: 'المستوى الدراسي',
                icon: Icons.school,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _healthStatusController,
                labelText: 'الحالة الصحية (إن وجد)',
                icon: Icons.local_hospital,
                isRequired: false,
              ),
              CustomTextField(
                controller: _maleSiblingsController,
                labelText: '(اختياري) عدد الاخوة الذكور',
                icon: Icons.person_outline,
                keyboardType: TextInputType.number,
                isRequired: false,
              ),
              CustomTextField(
                controller: _femaleSiblingsController,
                labelText: '(اختياري) عدد الاخوة الاناث',
                icon: Icons.person_outline,
                keyboardType: TextInputType.number,
                isRequired: false,
              ),
              const SizedBox(height: 16),
              if (state.isLoadingLevels)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<int>(
                  value: state.selectedLevelId,
                  hint: const Text('اختر مرحلة الطالب'),
                  items:
                      state.levels
                          .map(
                            (level) => DropdownMenuItem<int>(
                              value: level.id,
                              child: Text(level.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<AddStudentBloc>().add(LevelChanged(value));
                    }
                  },
                  validator:
                      (value) => value == null ? 'هذا الحقل مطلوب' : null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.stairs_outlined,
                      color: AppColors.steel_blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ];
  }
}
