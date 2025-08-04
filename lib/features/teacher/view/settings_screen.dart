// lib/features/teacher/view/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
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
        title: Text('الإعدادات', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('الحساب'),
          _buildSettingsTile(
            title: 'تعديل الملف الشخصي',
            subtitle: 'تغيير الاسم، رقم الهاتف...',
            icon: Icons.person,
            onTap: () {},
          ),
          _buildSettingsTile(
            title: 'تغيير كلمة المرور',
            subtitle: 'للحفاظ على أمان حسابك',
            icon: Icons.lock,
            onTap: () {},
          ),
          const Divider(),
          _buildSectionHeader('التطبيق'),
          SwitchListTile(
            title: Text('الإشعارات', style: GoogleFonts.tajawal()),
            subtitle: Text('تلقي إشعارات بالإعلانات والتنبيهات', style: GoogleFonts.tajawal()),
            secondary: const Icon(Icons.notifications),
            value: true, // TODO: ربطها بحالة من Bloc
            onChanged: (bool value) {},
            activeColor: AppColors.teal_blue,
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
              //  منطق تسجيل الخروج
              context.read<AuthBloc>().add(LoggedOut());
            },
          ),
        ],
      ),
    );
  }

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
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: GoogleFonts.tajawal()) : null,
      onTap: onTap,
    );
  }
}
