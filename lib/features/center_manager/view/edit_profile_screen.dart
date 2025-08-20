// // في lib/features/profile/view/edit_profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/data/models/center_maneger/profile_details_model.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/profile_bloc/profile_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// // استيراد البلوك والمودل

// class EditProfileScreen extends StatelessWidget {
//   const EditProfileScreen({super.key});

  
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: const Text('الملف الشخصي')),
//     body: BlocConsumer<ProfileBloc, ProfileState>(
//       listener: (context, state) {
//         // ==================== هنا هو الإصلاح ====================
//         // عرض رسائل الخطأ باستخدام SnackBar
//         if (state.status == ProfileStatus.failure && state.errorMessage != null) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage!),
//                 backgroundColor: Colors.red,
//               ),
//             );
//         }
//         // عرض رسالة نجاح عند التحديث
//         if (state.status == ProfileStatus.success && state.isEditModeEnabled == false) {
//            ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               const SnackBar(
//                 content: Text('تم تحديث الملف الشخصي بنجاح!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//         }
//         // =======================================================
//       },
//       builder: (context, state) {
//         // ==================== هنا هو الإصلاح ====================
//         // التحقق من حالة التحميل الأولية
//         if (state.status == ProfileStatus.loading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         // التحقق من فشل التحميل الأولي
//         if (state.profileData == null) {
//           return const Center(child: Text('فشل تحميل البيانات'));
//         }

//         // عرض واجهة التحميل أثناء التحقق من كلمة المرور أو التحديث
//         if (state.status == ProfileStatus.verifying || state.status == ProfileStatus.updating) {
//           return Stack(
//             children: [
//               // عرض الواجهة الحالية في الخلفية
//               state.isEditModeEnabled
//                   ? _buildEditableView(context, state.profileData!)
//                   : _buildReadOnlyView(context, state.profileData!),
//               // طبقة شفافة مع مؤشر تحميل
//               Container(
//                 color: Colors.black.withOpacity(0.3),
//                 child: const Center(child: CircularProgressIndicator(color: Colors.white)),
//               ),
//             ],
//           );
//         }

//         // إذا لم يتم تفعيل وضع التعديل، اعرض البيانات للقراءة فقط
//         if (!state.isEditModeEnabled) {
//           return _buildReadOnlyView(context, state.profileData!);
//         }

//         // إذا تم تفعيل وضع التعديل، اعرض الحقول القابلة للتعديل
//         return _buildEditableView(context, state.profileData!);
//         // =======================================================
//       },
//     ),
//   );
// }
//   // واجهة العرض فقط (مع زر لتفعيل التعديل)
//   Widget _buildReadOnlyView(BuildContext context, ProfileDetailsModel data) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildInfoCard('معلومات الحساب', {
//           'الاسم الكامل': data.name,
//           'البريد الإلكتروني': data.email,
//           'الحالة': data.userStatus,
//         }),
//         if (data.employeeId != null)
//           _buildInfoCard('معلومات الموظف', {
//             'الاسم الأول': data.firstName,
//             'الكنية': data.lastName,
//             'رقم الهاتف': data.phoneNumber,
//             'العنوان': data.address,
//             'المستوى التعليمي': data.educationLevel,
//             'تاريخ بدء العمل': data.startDate,
//             'المركز': data.centerName,
//           }),
//         if (data.adminId != null)
//           _buildInfoCard('معلومات إدارية', {
//             'نوع الإدارة': data.adminType,
//           }),
//         const SizedBox(height: 24),
//         ElevatedButton.icon(
//           icon: const Icon(Icons.lock_open_rounded),
//           label: const Text('تفعيل التعديل'),
//           onPressed: () => _showPasswordDialog(context),
//         ),
//       ],
//     );
//   }

//   // واجهة التعديل
//   Widget _buildEditableView(BuildContext context, ProfileDetailsModel data) {
//     // استخدم TextFormFields مع Controllers هنا
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         // ... حقول التعديل ...
//         const SizedBox(height: 24),
//         ElevatedButton.icon(
//           icon: const Icon(Icons.save_rounded),
//           label: const Text('حفظ التعديلات'),
//           onPressed: () {
//             // جمع البيانات من الـ Controllers وإرسال حدث SubmitProfileUpdate
//           },
//         ),
//       ],
//     );
//   }

//   // مربع حوار لإدخال كلمة المرور
//   void _showPasswordDialog(BuildContext context) {
//     final passwordController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: const Text('تأكيد الهوية'),
//         content: TextField(
//           controller: passwordController,
//           obscureText: true,
//           decoration: const InputDecoration(labelText: 'أدخل كلمة المرور الحالية'),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
//           ElevatedButton(
//             onPressed: () {
//               final password = passwordController.text;
//               if (password.isNotEmpty) {
//                 context.read<ProfileBloc>().add(VerifyPasswordAndEnableEdit(password));
//                 Navigator.pop(dialogContext);
//               }
//             },
//             child: const Text('تأكيد'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ويدجت مساعد لعرض بطاقات المعلومات
//   Widget _buildInfoCard(String title, Map<String, String?> fields) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
//             const Divider(height: 20),
//             ...fields.entries.map((entry) {
//               if (entry.value == null) return const SizedBox.shrink();
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(entry.key, style: GoogleFonts.tajawal(color: Colors.grey.shade600)),
//                     Text(entry.value!, style: GoogleFonts.tajawal(fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/features/profile/view/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/center_maneger/profile_details_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _educationLevelController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  
  // ✅ متغير لتتبع إذا تم الحفظ بنجاح
  bool _justUpdated = false;

  bool _controllersPopulated = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _educationLevelController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _populateControllers(ProfileDetailsModel data) {
    _nameController.text = data.name;
    _emailController.text = data.email;
    _firstNameController.text = data.firstName ?? '';
    _lastNameController.text = data.lastName ?? '';
    _fatherNameController.text = data.fatherName ?? '';
    _motherNameController.text = data.motherName ?? '';
    _phoneController.text = data.phoneNumber ?? '';
    _addressController.text = data.address ?? '';
    _educationLevelController.text = data.educationLevel ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        // ✅✅✅ إصلاح منطق الـ Listener ✅✅✅
        listener: (context, state) {
          // عرض رسائل الخطأ
          if (state.status == ProfileStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
          }
          
          // عند تفعيل وضع التعديل، قم بملء الحقول
          if (state.isEditModeEnabled && state.profileData != null) {
            _populateControllers(state.profileData!);
          }
 if (state.isEditModeEnabled && state.profileData != null && !_controllersPopulated) {
      _populateControllers(state.profileData!);
      setState(() {
        _controllersPopulated = true;
      });
    }
          // الشرط الصحيح: يتم التنفيذ فقط إذا كانت العملية السابقة هي التحديث
          if (_justUpdated && state.status == ProfileStatus.success && !state.isEditModeEnabled) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح!'), backgroundColor: Colors.green));
            Navigator.of(context).pop();
            _justUpdated = false; // إعادة تعيين المتغير
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.profileData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('فشل تحميل البيانات. حاول مرة أخرى.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    onPressed: () => context.read<ProfileBloc>().add(FetchProfile()),
                  )
                ],
              ),
            );
          }

          if (state.status == ProfileStatus.verifying || state.status == ProfileStatus.updating) {
            return Stack(
              children: [
                // عرض الواجهة الحالية في الخلفية
                state.isEditModeEnabled
                    ? _buildEditableView(context, state.profileData!)
                    : _buildReadOnlyView(context, state.profileData!),
                // طبقة شفافة مع مؤشر تحميل
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                ),
              ],
            );
          }

          return state.isEditModeEnabled
              ? _buildEditableView(context, state.profileData!)
              : _buildReadOnlyView(context, state.profileData!);
        },
      ),
    );
  }

  // ✅✅✅ استعادة التصميم الأفضل لواجهة العرض ✅✅✅
  Widget _buildReadOnlyView(BuildContext context, ProfileDetailsModel data) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard('معلومات الحساب', {
          'الاسم الكامل': data.name,
          'البريد الإلكتروني': data.email,
          'الحالة': data.userStatus,
        }),
        if (data.employeeId != null)
          _buildInfoCard('معلومات الموظف', {
            'الاسم الأول': data.firstName,
            'الكنية': data.lastName,
            'اسم الأب': data.fatherName,
            'اسم الأم': data.motherName,
            'رقم الهاتف': data.phoneNumber,
            'العنوان': data.address,
            'المستوى التعليمي': data.educationLevel,
            'تاريخ بدء العمل': data.startDate,
            'المركز': data.centerName,
          }),
        if (data.adminId != null)
          _buildInfoCard('معلومات إدارية', {
            'نوع الإدارة': data.adminType,
          }),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.lock_open_rounded),
          label: const Text('تفعيل التعديل'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
          onPressed: () => _showPasswordDialog(context),
        ),
      ],
    );
  }

  Widget _buildEditableView(BuildContext context, ProfileDetailsModel data) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('معلومات الحساب'),
          _buildTextFormField(_nameController, 'الاسم الكامل (للمستخدم)'),
          _buildTextFormField(_emailController, 'البريد الإلكتروني', isEmail: true),
          const SizedBox(height: 24),

          if (data.employeeId != null) ...[
            _buildSectionTitle('المعلومات الشخصية'),
            _buildTextFormField(_firstNameController, 'الاسم الأول'),
            _buildTextFormField(_lastNameController, 'الكنية'),
            _buildTextFormField(_fatherNameController, 'اسم الأب'),
            _buildTextFormField(_motherNameController, 'اسم الأم'),
            _buildTextFormField(_phoneController, 'رقم الهاتف', isPhone: true),
            _buildTextFormField(_addressController, 'العنوان'),
            _buildTextFormField(_educationLevelController, 'المستوى التعليمي'),
            const SizedBox(height: 24),
          ],

          _buildSectionTitle('تغيير كلمة المرور (اختياري)'),
          _buildTextFormField(_passwordController, 'كلمة المرور الجديدة', isPassword: true, isRequired: false),
          _buildTextFormField(_passwordConfirmationController, 'تأكيد كلمة المرور الجديدة', isPassword: true, isRequired: false,
            validator: (value) {
              if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
                return 'كلمتا المرور غير متطابقتين';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          ElevatedButton.icon(
            icon: const Icon(Icons.save_rounded),
            label: const Text('حفظ التعديلات'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // ✅ تعيين المتغير قبل إرسال الحدث
                setState(() {
                  _justUpdated = true;
                });
                final updateData = {
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'first_name': _firstNameController.text,
                  'last_name': _lastNameController.text,
                  'father_name': _fatherNameController.text,
                  'mother_name': _motherNameController.text,
                  'phone_number': _phoneController.text,
                  'address': _addressController.text,
                  'education_level': _educationLevelController.text,
                  if (_passwordController.text.isNotEmpty) 'password': _passwordController.text,
                  if (_passwordController.text.isNotEmpty) 'password_confirmation': _passwordConfirmationController.text,
                };
                context.read<ProfileBloc>().add(SubmitProfileUpdate(updateData));
              }
            },
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الهوية'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'أدخل كلمة المرور الحالية', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final password = passwordController.text;
              if (password.isNotEmpty) {
                context.read<ProfileBloc>().add(VerifyPasswordAndEnableEdit(password));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  // ✅✅✅ استعادة التصميم الأفضل للبطاقات ✅✅✅
  Widget _buildInfoCard(String title, Map<String, String?> fields) {
     return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark)),
            const Divider(height: 24, thickness: 0.5),
            ...fields.entries.where((e) => e.value != null && e.value!.isNotEmpty).map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${entry.key}: ', style: GoogleFonts.tajawal(fontWeight: FontWeight.w600, fontSize: 15)),
                    Expanded(child: Text(entry.value!, style: GoogleFonts.tajawal(fontSize: 15, color: Colors.black87))),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {bool isPassword = false, bool isEmail = false, bool isPhone = false, bool isRequired = true, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : (isPhone ? TextInputType.phone : TextInputType.text),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'هذا الحقل مطلوب';
          }
          if (isEmail && value != null && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'الرجاء إدخال بريد إلكتروني صالح';
          }
          if (validator != null) {
            return validator(value);
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
    );
  }
}