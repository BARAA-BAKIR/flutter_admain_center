import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/profile_boc/profile_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/profile_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/change_password_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String userName = '';
    String userEmail = '';

    if (authState is AuthAuthenticated) {
      userName = authState.user.name;
      userEmail = authState.user.email;
    }

    // ✅ لا حاجة لـ Scaffold أو AppBar هنا
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildUserProfileHeader(context, name: userName, email: userEmail),
        const SizedBox(height: 20),
        _buildSettingsTile(
          context,
          title: 'الملف الشخصي',
          subtitle: 'عرض وتعديل معلومات حسابك',
          icon: Icons.person_outline,
          onTap: () {
            // ✅ تمرير البلوك إلى الشاشة التالية
            context.read<ProfileBloc>().add(ProfileFetched());
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<ProfileBloc>(),
                      child: const ProfileScreen(),
                    ),
              ),
            );
          },
        ),
        const Divider(indent: 20, endIndent: 20, height: 1),
        _buildSettingsTile(
          context,
          title: 'تغيير كلمة المرور',
          subtitle: 'تحديث كلمة مرور حسابك لزيادة الأمان',
          icon: Icons.lock_outline,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
            );
          },
        ),
        const Divider(indent: 20, endIndent: 20, height: 1),
        _buildSettingsTile(
          context,
          title: 'تسجيل الخروج',
          subtitle: 'الخروج من حسابك الحالي',
          icon: Icons.exit_to_app_rounded,
          iconColor: Colors.red.shade700,
          textColor: Colors.red.shade700,
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  // واجهات مساعدة لتحسين المظهر
  Widget _buildUserProfileHeader(
    BuildContext context, {
    required String name,
    required String email,
  }) {
    return Container(
      color: AppColors.steel_blue,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: AppColors.steel_blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.tajawal(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: GoogleFonts.tajawal(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
        size: 28,
      ),
      title: Text(
        title,
        style: GoogleFonts.tajawal(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.tajawal(color: Colors.grey.shade600, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
                child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
