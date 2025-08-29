// // In lib/features/teacher/view/edit_profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/data/models/teacher/teacher_profile_model.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';

// // ====================  هنا هو الإصلاح الكامل والنهائي ====================

// // --- الويدجت الأولى: مسؤولة فقط عن توفير البلوك ---
// class EditProfileScreen extends StatelessWidget {
//   final TeacherProfile profile;
//   const EditProfileScreen({super.key, required this.profile});

//   @override
//   Widget build(BuildContext context) {
//     // نحن لا نوفر البلوك هنا، لأننا نفترض أنه تم توفيره من الشاشة السابقة
//     // هذا الكود سليم، المشكلة في كيفية استدعائه
//     return EditProfileView(profile: profile);
//   }
// }

// // --- الويدجت الثانية: مسؤولة عن بناء الواجهة الفعلية ---
// class EditProfileView extends StatefulWidget {
//   final TeacherProfile profile;
//   const EditProfileView({super.key, required this.profile});

//   @override
//   State<EditProfileView> createState() => _EditProfileViewState();
// }

// class _EditProfileViewState extends State<EditProfileView> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _firstNameController.text = widget.profile.firstName;
//     _lastNameController.text = widget.profile.lastName;
//     _phoneController.text = widget.profile.phoneNumber;
//     _addressController.text = widget.profile.address;
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     context.read<ProfileBloc>().add(
//           UpdateProfile(
//             firstName: _firstNameController.text,
//             lastName: _lastNameController.text,
//             phone: _phoneController.text,
//             address: _addressController.text,
//             currentPassword: _passwordController.text,
//           ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تعديل الملف الشخصي', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//         backgroundColor: AppColors.steel_blue,
//         foregroundColor: Colors.white,
//       ),
//       // الآن BlocListener سيجد البلوك فوقه في الشجرة
//       body: BlocListener<ProfileBloc, ProfileState>(
//         listener: (context, state) {
//           if (state.actionStatus == ProfileActionStatus.success) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 const SnackBar(content: Text('تم تحديث الملف بنجاح!'), backgroundColor: Colors.green),
//               );
//             Navigator.of(context).pop();
//           } else if (state.actionStatus == ProfileActionStatus.failure) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(content: Text('فشل التحديث: ${state.errorMessage}'), backgroundColor: Colors.red),
//               );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _firstNameController,
//                     decoration: const InputDecoration(labelText: 'الاسم الأول'),
//                     validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _lastNameController,
//                     decoration: const InputDecoration(labelText: 'الكنية'),
//                     validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _phoneController,
//                     decoration: const InputDecoration(labelText: 'رقم الهاتف'),
//                     keyboardType: TextInputType.phone,
//                     validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _addressController,
//                     decoration: const InputDecoration(labelText: 'العنوان'),
//                     validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
//                   ),
//                   const SizedBox(height: 24),
//                   const Divider(),
//                   const SizedBox(height: 12),
//                   Text(
//                     'لتأكيد التغييرات، يرجى إدخال كلمة المرور الحالية.',
//                     style: GoogleFonts.tajawal(color: Colors.grey.shade700),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(labelText: 'كلمة المرور الحالية'),
//                     obscureText: true,
//                     validator: (value) => value!.isEmpty ? 'كلمة المرور مطلوبة للتأكيد' : null,
//                   ),
//                   const SizedBox(height: 30),
//                   BlocBuilder<ProfileBloc, ProfileState>(
//                     builder: (context, state) {
//                       final isLoading = state.actionStatus == ProfileActionStatus.loading;
//                       return ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.steel_blue,
//                           foregroundColor: Colors.white,
//                           minimumSize: const Size(double.infinity, 48),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         onPressed: isLoading ? null : _submitForm,
//                         child: isLoading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : Text('حفظ التغييرات', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// In lib/features/teacher/view/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/teacher/teacher_profile_model.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatelessWidget {
  final TeacherProfile profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return EditProfileView(profile: profile);
  }
}

class EditProfileView extends StatefulWidget {
  final TeacherProfile profile;
  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  String? _selectedGender;
  DateTime? _selectedBirthDate;

  // In lib/features/teacher/view/edit_profile_screen.dart -> class _EditProfileViewState

@override
void initState() {
  super.initState();
  final p = widget.profile;
  _controllers = {
    'firstName': TextEditingController(text: p.firstName),
    'lastName': TextEditingController(text: p.lastName),
    'fatherName': TextEditingController(text: p.fatherName),
    'motherName': TextEditingController(text: p.motherName),
    'educationLevel': TextEditingController(text: p.educationLevel),
    'phone': TextEditingController(text: p.phoneNumber),
    'address': TextEditingController(text: p.address),
    'currentPassword': TextEditingController(),
    'newPassword': TextEditingController(),
    'newPasswordConfirmation': TextEditingController(),
  };

  // ====================  هنا هو الحل الكامل والنهائي ====================
  // 1. تحقق من قيمة الجنس القادمة من البروفايل
  final initialGender = p.gender;
  
  // 2. إذا كانت القيمة هي 'ذكر' أو 'أنثى'، استخدمها.
  //    وإلا (إذا كانت null أو أي شيء آخر)، اجعل القيمة الابتدائية null.
  //    هذا يضمن أن القيمة التي نعطيها للـ Dropdown هي دائمًا صالحة.
  if (initialGender == 'ذكر' || initialGender == 'أنثى') {
    _selectedGender = initialGender;
  } else {
    _selectedGender = null;
  }
  // =====================================================================

  _selectedBirthDate = p.birthDate;
}


  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileBloc>().add(UpdateProfile(
          firstName: _controllers['firstName']!.text,
          lastName: _controllers['lastName']!.text,
          fatherName: _controllers['fatherName']!.text,
          motherName: _controllers['motherName']!.text,
          birthDate: _selectedBirthDate,
          educationLevel: _controllers['educationLevel']!.text,
          gender: _selectedGender!,
          phoneNumber: _controllers['phone']!.text,
          address: _controllers['address']!.text,
          currentPassword: _controllers['currentPassword']!.text,
          newPassword: _controllers['newPassword']!.text,
          newPasswordConfirmation: _controllers['newPasswordConfirmation']!.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الملف الشخصي', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF0F4F8),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.actionStatus == ProfileActionStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('تم تحديث الملف بنجاح!'), backgroundColor: Colors.green));
            if (Navigator.canPop(context)) Navigator.of(context).pop();
          } else if (state.actionStatus == ProfileActionStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('فشل التحديث: ${state.errorMessage}'), backgroundColor: Colors.red));
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionCard(
                  title: 'المعلومات الأساسية',
                  icon: Icons.badge_outlined,
                  children: [
                    CustomTextField(controller: _controllers['firstName']!, labelText: 'الاسم الأول', icon: Icons.person, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _controllers['lastName']!, labelText: 'الكنية', icon: Icons.people, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _controllers['fatherName']!, labelText: 'اسم الأب', icon: Icons.man_3),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _controllers['motherName']!, labelText: 'اسم الأم', icon: Icons.woman_2),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: 'معلومات إضافية',
                  icon: Icons.info_outline,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: ['ذكر', 'أنثى'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                      onChanged: (newValue) => setState(() => _selectedGender = newValue),
                      decoration: const InputDecoration(labelText: 'الجنس', border: OutlineInputBorder(), prefixIcon: Icon(Icons.wc)),
                      validator: (v) => v == null ? 'الرجاء اختيار الجنس' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: _selectedBirthDate == null ? '' : DateFormat('yyyy-MM-dd').format(_selectedBirthDate!)),
                      decoration: InputDecoration(
                        labelText: 'تاريخ الميلاد',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.cake_outlined),
                        suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: () => _selectDate(context)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _controllers['educationLevel']!, labelText: 'المستوى العلمي', icon: Icons.school_outlined),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: 'معلومات الاتصال',
                  icon: Icons.contact_phone_outlined,
                  children: [
                    CustomTextField(controller: _controllers['phone']!, labelText: 'رقم الهاتف', icon: Icons.phone_android, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
                    const SizedBox(height: 16),
                    CustomTextField(controller: _controllers['address']!, labelText: 'مكان السكن', icon: Icons.location_on_outlined),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: 'تغيير كلمة المرور (اختياري)',
                  icon: Icons.key_outlined,
                  children: [
                    CustomTextField(controller: _controllers['newPassword']!, labelText: 'كلمة المرور الجديدة', icon: Icons.password, isPassword: true),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _controllers['newPasswordConfirmation']!,
                      labelText: 'تأكيد كلمة المرور الجديدة',
                      icon: Icons.password,
                      isPassword: true,
                      validator: (val) => val != _controllers['newPassword']!.text ? 'كلمتا المرور غير متطابقتين' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: 'تأكيد التغييرات',
                  icon: Icons.lock_outline,
                  isWarning: true,
                  children: [
                    CustomTextField(controller: _controllers['currentPassword']!, labelText: 'كلمة المرور الحالية (مطلوبة)', icon: Icons.shield_outlined, isPassword: true, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
                  ],
                ),
                const SizedBox(height: 30),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state.actionStatus == ProfileActionStatus.loading;
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.steel_blue, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      onPressed: isLoading ? null : _submitForm,
                      icon: isLoading ? const SizedBox.shrink() : const Icon(Icons.save_alt_rounded),
                      label: isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('حفظ التغييرات', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children, bool isWarning = false}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: isWarning ? Colors.orange.shade700 : AppColors.steel_blue),
                const SizedBox(width: 8),
                Text(title, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue)),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }
}
