// lib/features/center_manager/view/edit_teacher_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_diatls_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/edit_teacher_bloc/edit_teacher_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTeacherScreen extends StatefulWidget {
  final int teacherId;
  const EditTeacherScreen({super.key, required this.teacherId});

  @override
  State<EditTeacherScreen> createState() => _EditTeacherScreenState();
}

class _EditTeacherScreenState extends State<EditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isInitialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<EditTeacherBloc>().add(LoadTeacherForEdit(widget.teacherId));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _populateFields(TeacherDetailsModel data) {
    _firstNameController.text = data.firstName;
    _lastNameController.text = data.lastName;
    _fatherNameController.text = data.fatherName;
    _motherNameController.text = data.motherName;
    _phoneController.text = data.phoneNumber;
    _emailController.text = data.email;
    _isInitialDataLoaded = true;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'father_name': _fatherNameController.text,
        'mother_name': _motherNameController.text,
        'phone_number': _phoneController.text,
        'email': _emailController.text,
        if (_passwordController.text.isNotEmpty) 'password': _passwordController.text,
        if (_passwordController.text.isNotEmpty) 'password_confirmation': _passwordConfirmController.text,
      };
      context.read<EditTeacherBloc>().add(SubmitTeacherUpdate(teacherId: widget.teacherId, data: data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل بيانات الأستاذ',
          style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.steel_blue,
          foregroundColor: Colors.white,
        ),
      body: BlocConsumer<EditTeacherBloc, EditTeacherState>(
        listener: (context, state) {
          if (state.status == EditTeacherStatus.success && _isInitialDataLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم التحديث بنجاح'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(state.initialData); 
          }
          if (state.status == EditTeacherStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل: ${state.errorMessage ?? "خطأ غير معروف"}'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state.status == EditTeacherStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == EditTeacherStatus.success && !_isInitialDataLoaded && state.initialData != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _populateFields(state.initialData!);
              }
            });
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionCard(
                  title: 'المعلومات الشخصية',
                  child: Column(
                    children: [
                      // ✅ الإصلاح رقم 1: إضافة argument الـ icon المفقود
                      CustomTextField(controller: _firstNameController, labelText: 'الاسم الأول', icon: Icons.person, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                      CustomTextField(controller: _lastNameController, labelText: 'الكنية', icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                      CustomTextField(controller: _fatherNameController, labelText: 'اسم الأب', icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                      CustomTextField(controller: _motherNameController, labelText: 'اسم الأم', icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionCard(
                  title: 'معلومات التواصل والحساب',
                  child: Column(
                    children: [
                      CustomTextField(controller: _phoneController, labelText: 'رقم الهاتف', icon: Icons.phone, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                      CustomTextField(controller: _emailController, labelText: 'البريد الإلكتروني', icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !v.contains('@')) ? 'بريد إلكتروني غير صالح' : null),
                      const Divider(height: 32),
                      Text('تغيير كلمة المرور (اتركه فارغاً لعدم التغيير)', style: GoogleFonts.tajawal()),
                      const SizedBox(height: 16),
                      CustomTextField(controller: _passwordController, labelText: 'كلمة المرور الجديدة', icon: Icons.lock_outline, isPassword: true, validator: (v) {
                        if (v!.isNotEmpty && v.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
                        return null;
                      }),
                      CustomTextField(controller: _passwordConfirmController, labelText: 'تأكيد كلمة المرور', icon: Icons.lock_person, isPassword: true, validator: (v) {
                        if (_passwordController.text.isNotEmpty && v != _passwordController.text) return 'كلمتا المرور غير متطابقتين';
                        return null;
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: state.status == EditTeacherStatus.submitting ? null : _submitForm,
                  icon: state.status == EditTeacherStatus.submitting ? const SizedBox.shrink() : const Icon(Icons.save),
                  label: state.status == EditTeacherStatus.submitting ? const CircularProgressIndicator(color: Colors.white) : const Text('حفظ التعديلات'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue)),
            const Divider(height: 24, thickness: 0.5),
            child,
          ],
        ),
      ),
    );
  }
}
