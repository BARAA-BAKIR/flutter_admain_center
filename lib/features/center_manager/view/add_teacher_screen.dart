import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_teacher_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_teacher_bloc/add_teacher_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _educationLevelController = TextEditingController();
  final _startDateController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _memorizedPartsController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _gender = 'ذكر';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _educationLevelController.dispose();
    _startDateController.dispose();
    _documentNumberController.dispose();
    _memorizedPartsController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final teacherData = AddTeacherModel(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        fatherName: _fatherNameController.text,
        motherName: _motherNameController.text,
        birthDate: _birthDateController.text,
        educationLevel: _educationLevelController.text,
        startDate: _startDateController.text,
        documentNumber: _documentNumberController.text,
        gender: _gender,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        memorizedParts: int.tryParse(_memorizedPartsController.text) ?? 0,
      );
      context.read<AddTeacherBloc>().add(SubmitNewTeacher(teacherData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة أستاذ جديد', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AddTeacherBloc, AddTeacherState>(
        listener: (context, state) {
          if (state.status == AddTeacherStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة الأستاذ بنجاح'), backgroundColor: Colors.green));
            Navigator.of(context).pop(state.createdTeacher);
          }
          if (state.status == AddTeacherStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل: ${state.errorMessage ?? "خطأ غير معروف"}'), backgroundColor: Colors.red));
          }
        },
        child: Form(
          key: _formKey,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            onStepContinue: () {
              final isLastStep = _currentStep == _buildSteps().length - 1;
              if (isLastStep) {
                _submitForm();
              } else {
                setState(() => _currentStep += 1);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            steps: _buildSteps(),
            controlsBuilder: (context, details) {
              return BlocBuilder<AddTeacherBloc, AddTeacherState>(
                builder: (context, state) {
                  if (state.status == AddTeacherStatus.submitting) {
                    return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator()));
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (details.currentStep > 0)
                          TextButton(onPressed: details.onStepCancel, child: const Text('السابق')),
                        
                        ElevatedButton.icon(
                          onPressed: details.onStepContinue,
                          icon: Icon(details.currentStep == _buildSteps().length - 1 ? Icons.person_add : Icons.arrow_forward),
                          label: Text(details.currentStep == _buildSteps().length - 1 ? 'إضافة الأستاذ' : 'التالي'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.steel_blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('الشخصية'),
        isActive: _currentStep >= 0,
        content: Column(
          children: [
            CustomTextField(controller: _firstNameController, labelText: 'الاسم الأول', icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            CustomTextField(controller: _lastNameController, labelText: 'الكنية', icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            CustomTextField(controller: _fatherNameController, labelText: 'اسم الأب', icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            CustomTextField(controller: _motherNameController, labelText: 'اسم الأم', icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            CustomTextField(controller: _birthDateController, labelText: 'تاريخ الميلاد', icon: Icons.calendar_today_outlined, readOnly: true, onTap: () async {
              DateTime? date = await showDatePicker(context: context, initialDate: DateTime(1990), firstDate: DateTime(1950), lastDate: DateTime.now());
              if (date != null) _birthDateController.text = DateFormat('yyyy-MM-dd').format(date);
            }, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
          ],
        ),
      ),
      Step(
        title: const Text('التواصل'),
        isActive: _currentStep >= 1,
        content: Column(
          children: [
            CustomTextField(controller: _phoneController, labelText: 'رقم الهاتف', icon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            CustomTextField(controller: _addressController, labelText: 'العنوان', icon: Icons.home_outlined, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            DropdownButtonFormField<String>(
              value: _gender,
              items: ['ذكر', 'أنثى'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => _gender = value!),
              decoration: const InputDecoration(labelText: 'الجنس', prefixIcon: Icon(Icons.wc_outlined)),
            ),
          ],
        ),
      ),
      Step(
        title: const Text('الوظيفة والحساب'),
        isActive: _currentStep >= 2,
        content: Column(
          children: [
            CustomTextField(controller: _educationLevelController, labelText: 'المستوى التعليمي', icon: Icons.school_outlined, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            CustomTextField(controller: _startDateController, labelText: 'تاريخ بدء العمل', icon: Icons.work_history_outlined, readOnly: true, onTap: () async {
              DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2010), lastDate: DateTime.now());
              if (date != null) _startDateController.text = DateFormat('yyyy-MM-dd').format(date);
            }, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            CustomTextField(controller: _documentNumberController, labelText: 'رقم الوثيقة', icon: Icons.badge_outlined, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            CustomTextField(controller: _memorizedPartsController, labelText: 'عدد الأجزاء المحفوظة', icon: Icons.menu_book_outlined, keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
            const Divider(height: 32, thickness: 1),
            Text("معلومات تسجيل الدخول", style: GoogleFonts.tajawal(fontSize: 16, color: AppColors.steel_blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CustomTextField(controller: _emailController, labelText: 'البريد الإلكتروني', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !v.contains('@')) ? 'بريد إلكتروني غير صالح' : null),
            CustomTextField(controller: _passwordController, labelText: 'كلمة المرور', icon: Icons.lock_outline, isPassword: true, validator: (v) => (v == null || v.length < 8) ? 'كلمة المرور قصيرة جداً' : null),
          ],
        ),
      ),
    ];
  }
}
