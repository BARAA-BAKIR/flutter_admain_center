
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/add_student/add_student_bloc.dart';

// List<Step> buildSteps(BuildContext context, AddStudentState state) {
//     return [
//       Step(
//         title: const Text('المعلومات الشخصية'),
//         isActive: state.currentStep >= 0,
//         content: Form(
//           key: _formKeyStep1,
//           child: Column(
//             children: [
//               CustomTextField(
//                 controller: _firstNameController,
//                 labelText: 'الاسم الأول',
//                 icon: Icons.person,
//                 validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
//               ),
//               CustomTextField(
//                 controller: _lastNameController,
//                 labelText: 'الكنية',
//                 icon: Icons.person_outline,
//                 validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
//               ),
//               CustomTextField(
//                 controller: _fatherNameController,
//                 labelText: 'اسم الأب',
//                 icon: Icons.person_outline,
//                 validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
//               ),
//               CustomTextField(
//                 controller: _motherNameController,
//                 labelText: 'اسم الأم',
//                 icon: Icons.person_outline,
//                 validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
//               ),
//               //email
//               CustomTextField(
//                 controller: _emailController,
//                 labelText: 'البريد الإلكتروني',
//                 icon: Icons.email,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
//               ),
//               CustomTextField(
//                 controller: _birthDateController,
//                 labelText: 'تاريخ الميلاد',
//                 icon: Icons.calendar_today,
//                 readOnly: true,
//                 onTap: () async {
//                   DateTime? date = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime(2000),
//                     firstDate: DateTime(1950),
//                     lastDate: DateTime.now(),
//                   );
//                   if (date != null) {
//                     _birthDateController.text = DateFormat(
//                       'yyyy-MM-dd',
//                     ).format(date);
//                   }
//                 },
//                 validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text('الجنس:', style: GoogleFonts.tajawal(fontSize: 16)),
//                     Radio<String>(
//                       value: 'ذكر',
//                       groupValue: state.gender,
//                       onChanged:
//                           (v) => context.read<AddStudentBloc>().add(
//                             GenderChanged(v!),
//                           ),
//                     ),
//                     Text('ذكر', style: GoogleFonts.tajawal()),
//                     Radio<String>(
//                       value: 'أنثى',
//                       groupValue: state.gender,
//                       onChanged:
//                           (v) => context.read<AddStudentBloc>().add(
//                             GenderChanged(v!),
//                           ),
//                     ),
//                     Text('أنثى', style: GoogleFonts.tajawal()),
//                   ],

//                   // --- هذا هو الإصلاح ---
//                   //الحالة الاجتماعية متزوج او اعزب وافترا
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'الحالة الاجتماعية:',
//                       style: GoogleFonts.tajawal(fontSize: 16),
//                     ),
//                     Radio<String>(
//                       value: 'اعزب',
//                       groupValue: state.social_status,
//                       onChanged:
//                           (v) => context.read<AddStudentBloc>().add(
//                             SocialStatusChanged(v!),
//                           ),
//                     ),
//                     Text('اعزب', style: GoogleFonts.tajawal()),
//                     Radio<String>(
//                       value: 'متزوج',
//                       groupValue: state.social_status,
//                       onChanged:
//                           (v) => context.read<AddStudentBloc>().add(
//                             SocialStatusChanged(v!),
//                           ),
//                     ),
//                     Text('متزوج', style: GoogleFonts.tajawal()),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       Step(
//         title: const Text('معلومات إضافية وحساب'),
//         isActive: state.currentStep >= 1,
//         content: Form(
//           key: _formKeyStep2,
//           child: Column(
//             children: [
//               CustomTextField(
//                 controller: _phoneController,
//                 labelText: 'رقم الهاتف (سيكون اسم المستخدم)',
//                 icon: Icons.phone,
//                 keyboardType: TextInputType.phone,
//                 validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
//               ),
//               CustomTextField(
//                 controller: _passwordController,
//                 labelText: 'كلمة المرور للطالب',
//                 icon: Icons.lock,
//                 isPassword: true,
//                 validator:
//                     (v) => v!.length < 6 ? 'كلمة المرور قصيرة جداً' : null,
//               ),

//               CustomTextField(
//                 controller: _educationalLevelController,
//                 labelText: 'المستوى الدراسي',
//                 icon: Icons.school,
//                 validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
//               ),
//               CustomTextField(
//                 controller: _healthStatusController,
//                 labelText: 'الحالة الصحية (إن وجد)',
//                 icon: Icons.local_hospital,
//                 isRequired: false,
//               ),
//               CustomTextField(
//                 controller: _maleSiblingsController,
//                 labelText: '(اختياري) عدد الاخوة الذكور',
//                 icon: Icons.person_outline,
//                 keyboardType: TextInputType.number,
//                 isRequired: false,
//               ),
//               CustomTextField(
//                 controller: _femaleSiblingsController,
//                 labelText: '(اختياري) عدد الاخوة الاناث',
//                 icon: Icons.person_outline,
//                 keyboardType: TextInputType.number,
//                 isRequired: false,
//               ),
//               const SizedBox(height: 16),
//               if (state.isLoadingLevels)
//                 const Center(child: CircularProgressIndicator())
//               else
//                 DropdownButtonFormField<int>(
//                   value: state.selectedLevelId,
//                   hint: const Text('اختر مرحلة الطالب'),
//                   items:
//                       state.levels
//                           .map(
//                             (level) => DropdownMenuItem<int>(
//                               value: level.id,
//                               child: Text(level.name),
//                             ),
//                           )
//                           .toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       context.read<AddStudentBloc>().add(LevelChanged(value));
//                     }
//                   },
//                   validator:
//                       (value) => value == null ? 'هذا الحقل مطلوب' : null,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.stairs_outlined,
//                       color: AppColors.steel_blue,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     ];
//   }