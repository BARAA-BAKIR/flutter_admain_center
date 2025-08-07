import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
// استيراد الشاشات التي سننتقل إليها
// import 'package:flutter_admain_center/features/teacher/view/profile_screen.dart';
// import 'package:flutter_admain_center/features/teacher/view/change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام BlocBuilder لجلب بيانات المستخدم وعرضها
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // التأكد من أن المستخدم مسجل دخوله لعرض بياناته
        if (state is! AuthAuthenticated) {
          // حالة غير متوقعة، يجب ألا يصل المستخدم إلى هنا أصلاً
          return const Scaffold(body: Center(child: Text('المستخدم غير مسجل دخوله')));
        }

        // الآن لدينا وصول آمن لبيانات المستخدم
        final user = state.user;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text('الإعدادات', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- قسم معلومات الحساب ---
              _buildUserProfileHeader(context, name: user.name, email: user.email),
              const SizedBox(height: 24),

              // --- قسم إدارة الحساب ---
              _buildSectionTitle('إدارة الحساب'),
              _buildSettingsCard(
                children: [
                  _buildSettingsTile(
                    context,
                    title: 'تعديل الملف الشخصي',
                    icon: Icons.edit_rounded,
                    onTap: () { /* TODO: Navigate to EditProfileScreen */ },
                  ),
                  const Divider(height: 1),
                  _buildSettingsTile(
                    context,
                    title: 'تغيير كلمة المرور',
                    icon: Icons.lock_reset_rounded,
                    onTap: () { /* TODO: Navigate to ChangePasswordScreen */ },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- قسم الإشعارات والموافقات (يظهر حسب الصلاحية) ---
              if (user.hasRole('مدير عام') || user.hasRole('مدير مركز'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('الإشعارات والموافقات'),
                    _buildSettingsCard(
                      children: [
                        _buildSettingsTile(
                          context,
                          title: 'طلبات التسجيل المعلقة',
                          icon: Icons.pending_actions_rounded,
                          trailing: const Badge(label: Text('3')), // مثال
                          onTap: () { /* TODO: Navigate to ApprovalsScreen */ },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: Text('تلقي الإشعارات', style: GoogleFonts.tajawal()),
                          secondary: const Icon(Icons.notifications_active_rounded, color: AppColors.night_blue),
                          value: true, // TODO: ربطها بحالة من Bloc
                          onChanged: (bool value) {},
                          activeColor: AppColors.teal_blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),

              // --- قسم تسجيل الخروج ---
              ElevatedButton.icon(
                icon: const Icon(Icons.logout_rounded),
                label: Text('تسجيل الخروج', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                onPressed: () {
                  // إظهار رسالة تأكيد قبل الخروج
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('تسجيل الخروج'),
                      content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(LoggedOut());
                            Navigator.of(ctx).pop(); // إغلاق الحوار
                          },
                          child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ويدجت لعرض معلومات المستخدم في الأعلى
  Widget _buildUserProfileHeader(BuildContext context, {required String name, required String email}) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: AppColors.steel_blue,
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(email, style: GoogleFonts.tajawal(color: Colors.grey.shade600)),
          ],
        ),
      ],
    );
  }

  // ويدجت لعرض عنوان كل قسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.tajawal(color: Colors.grey.shade600, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  // ويدجت لإنشاء بطاقة تحتوي على خيارات الإعدادات
  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // لضمان تطبيق الحواف الدائرية على المحتوى
      child: Column(
        children: children,
      ),
    );
  }

  // ويدجت لعرض كل خيار في الإعدادات
  Widget _buildSettingsTile(BuildContext context, {required String title, required IconData icon, VoidCallback? onTap, Widget? trailing}) {
    return ListTile(
      title: Text(title, style: GoogleFonts.tajawal()),
      leading: Icon(icon, color: AppColors.night_blue),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
