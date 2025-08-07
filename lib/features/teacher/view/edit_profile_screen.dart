// in lib/features/teacher/view/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/teacher/teacher_profile_model.dart'; // تأكد من استيراد الموديل
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  // نستقبل بيانات البروفايل الحالية لتعبئة الحقول
  final TeacherProfile profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  // تم دمج اسمي العلم والكنية في حقل واحد
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // نملأ الحقول بالبيانات الحالية التي تم تمريرها للشاشة
    _firstNameController.text = widget.profile.firstName;
    _lastNameController.text = widget.profile.lastName;
    _phoneController.text = widget.profile.phoneNumber;
    _addressController.text = widget.profile.address;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // التحقق من صحة النموذج
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // إرسال حدث التحديث إلى البلوك
    context.read<ProfileBloc>().add(
          UpdateProfile(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            phone: _phoneController.text,
            address: _addressController.text,
           currentPassword: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الملف الشخصي', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.actionStatus == ProfileActionStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('تم تحديث الملف بنجاح!'), backgroundColor: Colors.green),
              );
            // بعد النجاح، نعود للشاشة السابقة
            Navigator.of(context).pop();
          } else if (state.actionStatus == ProfileActionStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('فشل التحديث: ${state.errorMessage}'), backgroundColor: Colors.red),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'الاسم الأول'),
                    validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'الكنية'),
                    validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'العنوان'),
                    validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'لتأكيد التغييرات، يرجى إدخال كلمة المرور الحالية.',
                    style: GoogleFonts.tajawal(color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'كلمة المرور الحالية'),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'كلمة المرور مطلوبة للتأكيد' : null,
                  ),
                  const SizedBox(height: 30),
                  // استخدام BlocBuilder للتحكم في حالة الزر
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      final isLoading = state.actionStatus == ProfileActionStatus.loading;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.steel_blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isLoading ? null : _submitForm,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text('حفظ التغييرات', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
