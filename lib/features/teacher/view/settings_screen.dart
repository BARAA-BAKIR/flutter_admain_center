// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';

// import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/settings/settings_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/view/change_password_screen.dart';
// // -----------------------------------------------------------------
// import 'package:flutter_admain_center/features/teacher/view/edit_profile_screen.dart';
// import 'package:flutter_admain_center/features/teacher/view/profile_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(
//           'الإعدادات',
//           style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppColors.steel_blue,
//         foregroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: [
//           _buildSectionHeader('الحساب'),
//           _buildSettingsTile(
//             title: 'تعديل الملف الشخصي',
//             subtitle: 'تغيير الاسم، رقم الهاتف...',
//             icon: Icons.person,
//             onTap: () {
//               final currentProfile = context.read<ProfileBloc>().state.profile;
//               if (currentProfile != null) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder:
//                         (_) => BlocProvider.value(
//                           // نحن نمرر نفس نسخة البلوك الحالية
//                           value: context.read<ProfileBloc>(),
//                           child: EditProfileScreen(profile: currentProfile),
//                         ),
//                   ),
//                 );
//               }
//               // },
//               // } else {
//               //   // **الحالة الشائعة:** البيانات غير موجودة (state.profile is null).
//               //   // لا يمكننا الانتقال إلى شاشة التعديل مباشرة.
//               //   // الحل: انتقل أولاً إلى شاشة عرض الملف الشخصي (ProfileScreen).
//               //   // شاشة ProfileScreen مصممة لتقوم تلقائياً بطلب البيانات في initState.
//               //   // بعد أن يتم تحميل البيانات فيها، يمكن للمستخدم الضغط على زر التعديل هناك بأمان.
//               //   Navigator.of(context).push(
//               //     MaterialPageRoute(
//               //       builder: (_) => const ProfileScreen(),
//               //     ),
//               //   );
//               // }
//               // ==============================================================
//             },
//           ),
//           _buildSettingsTile(
//             title: 'تغيير كلمة المرور',
//             subtitle: 'للحفاظ على أمان حسابك',
//             icon: Icons.lock,
//             onTap: () {
//               // -------------------  التغيير هنا -------------------
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
//               );
//               // ----------------------------------------------------
//             },
//           ),

//           const Divider(),
//           _buildSectionHeader('التطبيق'),
//           BlocBuilder<SettingsBloc, SettingsState>(
//             builder: (context, state) {
//               return SwitchListTile(
//                 title: Text('الإشعارات', style: GoogleFonts.tajawal()),
//                 subtitle: Text(
//                   'تلقي إشعارات بالإعلانات والتنبيهات',
//                   style: GoogleFonts.tajawal(),
//                 ),
//                 secondary: const Icon(Icons.notifications),
//                 value: state.isNotificationsEnabled, // **ربط الحالة هنا**
//                 onChanged: (bool value) {
//                   context.read<SettingsBloc>().add(
//                     ToggleNotifications(),
//                   ); // **إرسال حدث**
//                 },
//                 activeColor: AppColors.teal_blue,
//               );
//             },
//           ),
//           _buildSettingsTile(
//             title: 'عن التطبيق',
//             subtitle: 'الإصدار 1.0.0',
//             icon: Icons.info,
//             onTap: () {},
//           ),
//           const Divider(color: Colors.red, thickness: 1),
//           _buildSettingsTile(
//             title: 'تسجيل الخروج',
//             subtitle: '',
//             icon: Icons.exit_to_app,
//             color: Colors.red,
//              onTap: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (dialogContext) => AlertDialog(
//                       title: const Text('تسجيل الخروج'),
//                       content: const Text(
//                         'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(dialogContext).pop(),
//                           child: const Text('إلغاء'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             // 1. أغلق مربع الحوار
//                             Navigator.of(dialogContext).pop();

//                             //    اذهب لشاشة الدخول
//                             context.read<AuthBloc>().add(LoggedOut());
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text(
//                             'تأكيد',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                       ],
//                     ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Text(
//         title,
//         style: GoogleFonts.tajawal(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: AppColors.steel_blue,
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingsTile({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color ?? AppColors.night_blue),
//       title: Text(title, style: GoogleFonts.tajawal(color: color)),
//       subtitle:
//           subtitle.isNotEmpty
//               ? Text(subtitle, style: GoogleFonts.tajawal())
//               : null,
//       onTap: onTap,
//     );
//   }
// }
// In lib/features/teacher/view/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/settings/settings_bloc.dart';
import 'package:flutter_admain_center/features/teacher/view/change_password_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/edit_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('الحساب'),

          // ====================  هنا هو الإصلاح الكامل والنهائي ====================
          // لم نعد نستخدم _buildSettingsTile هنا، بل نستخدم ListTile مباشرة
          // لنتمكن من الوصول إلى context بشكل صحيح.
          ListTile(
            leading: const Icon(Icons.person, color: AppColors.night_blue),
            title: Text('تعديل الملف الشخصي', style: GoogleFonts.tajawal()),
            subtitle: Text(
              'تغيير الاسم، رقم الهاتف...',
              style: GoogleFonts.tajawal(),
            ),
            onTap: () {
              // الآن هذا الكود سيعمل بشكل صحيح
              final currentProfile = context.read<ProfileBloc>().state.profile;
              if (currentProfile != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value: context.read<ProfileBloc>(),
                          child: EditProfileScreen(profile: currentProfile),
                        ),
                  ),
                );
              } else {
                // يمكنك عرض رسالة للمستخدم هنا إذا لم يتم تحميل البروفايل بعد
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'جاري تحميل بيانات الملف الشخصي، يرجى المحاولة بعد لحظات.',
                    ),
                  ),
                );
                // ومحاولة جلبه مرة أخرى
                context.read<ProfileBloc>().add(FetchProfileData());
              }
            },
          ),

          // =====================================================================
          _buildSettingsTile(
            title: 'تغيير كلمة المرور',
            subtitle: 'للحفاظ على أمان حسابك',
            icon: Icons.lock,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              );
            },
          ),

          const Divider(),
          _buildSectionHeader('التطبيق'),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return SwitchListTile(
                title: Text('الإشعارات', style: GoogleFonts.tajawal()),
                subtitle: Text(
                  'تلقي إشعارات بالإعلانات والتنبيهات',
                  style: GoogleFonts.tajawal(),
                ),
                secondary: const Icon(Icons.notifications),
                value: state.isNotificationsEnabled,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(ToggleNotifications());
                },
                activeColor: AppColors.teal_blue,
              );
            },
          ),
          _buildSettingsTile(
            title: 'عن التطبيق',
            subtitle: 'الإصدار 1.0.0',
            icon: Icons.info,
            onTap: () {},
          ),
          const Divider(color: Colors.red, thickness: 1),
          _buildSettingsTile(
            title: 'تسجيل الخروج',
            subtitle: '',
            icon: Icons.exit_to_app,
            color: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (dialogContext) => AlertDialog(
                      title: const Text('تسجيل الخروج'),
                      content: const Text(
                        'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            // 1. أغلق مربع الحوار
                            Navigator.of(dialogContext).pop();

                            //    اذهب لشاشة الدخول
                            context.read<AuthBloc>().add(AuthLogoutRequested());
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'تأكيد',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  // هذه الدوال المساعدة تبقى كما هي
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.steel_blue,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.night_blue),
      title: Text(title, style: GoogleFonts.tajawal(color: color)),
      subtitle:
          subtitle.isNotEmpty
              ? Text(subtitle, style: GoogleFonts.tajawal())
              : null,
      onTap: onTap,
    );
  }
}
