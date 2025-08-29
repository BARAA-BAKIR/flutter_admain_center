import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/teacher/view/edit_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
            onPressed: () {
              final currentProfile = context.read<ProfileBloc>().state.profile;
              if (currentProfile != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          // نحن نمرر نفس نسخة البلوك الحالية
                          value: context.read<ProfileBloc>(),
                          child: EditProfileScreen(profile: currentProfile),
                        ),
                  ),
                );
              }

              // } else {
              //                 // إذا كانت البيانات غير متاحة لسبب ما، أبلغ المستخدم
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   const SnackBar(
              //                     content: Text('لا يمكن التعديل قبل تحميل البيانات بنجاح.'),
              //                     backgroundColor: Colors.orange,
              //                     duration: Duration(seconds: 2),
              //                     behavior: SnackBarBehavior.floating,
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.all(Radius.circular(10)),
              //                     ),
              //                   ),
              //                 );
              //               }
              // ==============================================================
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // ... (بقية الكود الخاص بك سليم ولا يحتاج تعديل)
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ProfileStatus.failure) {
            return Center(
              child: Text(
                'خطأ: ${state.errorMessage}',
                style: GoogleFonts.tajawal(color: Colors.red),
              ),
            );
          } else if (state.status == ProfileStatus.success &&
              state.profile != null) {
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
                _buildInfoTile('تاريخ الميلاد', user.birthDate != null
                    ? '${user.birthDate!.year}-${user.birthDate!.month.toString().padLeft(2, '0')}-${user.birthDate!.day.toString().padLeft(2, '0')}'
                    : ''),
                _buildInfoTile('المستوى التعليمي', user.educationLevel ?? ''),
                _buildInfoTile('تاريخ بداية العمل', user.startDate != null
                    ? '${user.startDate!.year}-${user.startDate!.month.toString().padLeft(2, '0')}-${user.startDate!.day.toString().padLeft(2, '0')}'
                    : ''),
                _buildInfoTile('العنوان', user.address ?? ''),
              ],
            );
          }
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
