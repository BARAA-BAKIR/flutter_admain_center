
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';

import 'package:flutter_admain_center/features/teacher/view/edit_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // هذا الجزء سليم، يطلب البيانات عند فتح الشاشة
    context.read<ProfileBloc>().add(FetchProfileData());
  }

  void _showPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    final profileBloc = context.read<ProfileBloc>(); // اقرأ البلوك مرة واحدة

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: profileBloc, // مرر نفس نسخة البلوك للحوار
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              // استمع لحالة التحقق من كلمة المرور
              if (state.actionStatus == ProfileActionStatus.passwordVerified) {
                Navigator.of(dialogContext).pop(); // أغلق الحوار

                // انتقل إلى شاشة التعديل
                final currentProfile = profileBloc.state.profile;
                if (currentProfile != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider.value(
                            value: profileBloc,
                            child: EditProfileScreen(profile: currentProfile),
                          ),
                    ),
                  );
                }
              }
              // في حالة فشل التحقق
              if (state.actionStatus == ProfileActionStatus.failure) {
                Navigator.of(dialogContext).pop(); // أغلق الحوار
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'كلمة المرور غير صحيحة',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return AlertDialog(
                  title: const Text('التحقق الأمني'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'لتعديل ملفك الشخصي، يرجى إدخال كلمة المرور الحالية.',
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور',
                        ),
                        autocorrect: false,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      // تعطيل الزر أثناء التحميل
                      onPressed:
                          state.actionStatus == ProfileActionStatus.loading
                              ? null
                              : () {
                                if (passwordController.text.isNotEmpty) {
                                  profileBloc.add(
                                    VerifyPasswordForEdit(
                                      passwordController.text,
                                    ),
                                  );
                                }
                              },
                      child:
                          state.actionStatus == ProfileActionStatus.loading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                              : const Text('تحقق'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'ملفي الشخصي',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            // ✅✅✅ استدعاء دالة الحوار عند الضغط ✅✅✅
            onPressed: () => _showPasswordDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        // ✅ الإصلاح: استخدم buildWhen لضمان إعادة البناء فقط عند تغير البيانات الرئيسية
        buildWhen:
            (previous, current) =>
                previous.status != current.status ||
                previous.profile != current.profile,
        builder: (context, state) {
          // ✅ الإصلاح: تحقق من `state.status` (من نوع ProfileStatus)
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfileStatus.failure) {
            return Center(
              child: Text(
                'خطأ: ${state.errorMessage}',
                style: GoogleFonts.tajawal(color: Colors.red),
              ),
            );
          }

          // ✅ الإصلاح: تحقق من وجود البيانات بعد التأكد من حالة النجاح
          if (state.status == ProfileStatus.success && state.profile != null) {
            final user = state.profile!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildInfoTile(
                  'الاسم الكامل',
                  '${user.firstName} ${user.lastName}',
                ),
                _buildInfoTile('اسم الأب', user.fatherName ?? ''),
                _buildInfoTile('اسم الأم', user.motherName ?? ''),
                _buildInfoTile('البريد الإلكتروني', user.email),
                _buildInfoTile('رقم الهاتف', user.phoneNumber),
                _buildInfoTile(
                  'تاريخ الميلاد',
                  user.birthDate != null
                      ? DateFormat('yyyy-MM-dd').format(user.birthDate!)
                      : '',
                ),
                _buildInfoTile('المستوى التعليمي', user.educationLevel ?? ''),
                _buildInfoTile(
                  'تاريخ بداية العمل',
                  user.startDate != null
                      ? DateFormat('yyyy-MM-dd').format(user.startDate!)
                      : '',
                ),
                _buildInfoTile('العنوان', user.address ?? ''),
                _buildInfoTile('اسم المركز', user.centerName ?? ''),
              ],
            );
          }

          // هذه الحالة ستظهر فقط إذا كانت الحالة success ولكن profile هو null، أو في الحالة الأولية
          return const Center(child: Text('لا توجد بيانات لعرضها.'));
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.tajawal(color: Colors.grey.shade600),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
