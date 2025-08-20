import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/notifications_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/change_password_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // <-- إضافة Scaffold هنا
      appBar: AppBar(
        // <-- إضافة AppBar هنا
        title: Text(
          'الإعدادات',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100, // <-- إضافة لون خلفية
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: Text('المستخدم غير مسجل دخوله'));
          }

          final user = state.user;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- قسم معلومات الحساب ---
              _buildUserProfileHeader(
                context,
                name: user.name,
                email: user.email,
              ),
              const SizedBox(height: 24),

              // --- قسم إدارة الحساب ---
              _buildSectionTitle('إدارة الحساب'),
              _buildSettingsCard(
                children: [
                  _buildSettingsTile(
                    context,
                    title: 'تعديل الملف الشخصي',
                    icon: Icons.edit_rounded,
                    onTap: () {
                      /* TODO: Navigate to EditProfileScreen */
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsTile(
                    context,
                    title: 'تغيير كلمة المرور',
                    icon: Icons.lock_reset_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      );
                    },
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
                        // ==================== هنا هو الإصلاح الكامل والنهائي ====================
                        // 1. لف هذا الخيار بـ BlocBuilder للاستماع إلى NotificationsBloc
                        BlocBuilder<NotificationsBloc, NotificationsState>(
                          builder: (context, notificationsState) { // <-- استخدام اسم مختلف للحالة
                            return _buildSettingsTile(
                              context,
                              title: 'طلبات التسجيل المعلقة',
                              icon: Icons.pending_actions_rounded,
                              // 2. عرض العدد الحقيقي من الحالة
                              trailing: badges.Badge(
                                showBadge: notificationsState.unreadCount > 0, // إظهار الشارة فقط إذا كان العدد أكبر من صفر
                                badgeContent: Text(
                                  notificationsState.unreadCount.toString(), // <-- استخدام العدد الحقيقي
                                  style: const TextStyle(color: Colors.white),
                                ),
                                child: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ),
                              onTap: () {
                                // 3. الانتقال إلى شاشة الطلبات (ApprovalsScreen)
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationsScreen(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // ====================================================================
                        const Divider(height: 1),
                        SwitchListTile(
                          title: Text('تلقي الإشعارات', style: GoogleFonts.tajawal()),
                          secondary: const Icon(Icons.notifications_active_rounded, color: AppColors.night_blue),
                          value: true,
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
                label: Text(
                  'تسجيل الخروج',
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('تسجيل الخروج'),
                          content: const Text(
                            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(LoggedOut());

                                // أغلق مربع الحوار فقط
                                Navigator.of(ctx).pop();
                                // =======================================================
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ويدجت لعرض معلومات المستخدم في الأعلى
  Widget _buildUserProfileHeader(
    BuildContext context, {
    required String name,
    required String email,
  }) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: AppColors.steel_blue,
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(width: 16),
        // ==================== هنا هو الإصلاح ====================
        // قم بلف الـ Column بويدجت Expanded
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // استخدم softWrap: true للسماح للنصوص بالالتفاف إذا كانت طويلة
              Text(
                name,
                style: GoogleFonts.tajawal(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow:
                    TextOverflow
                        .ellipsis, // يضيف "..." إذا كان النص طويلاً جداً
              ),
              Text(
                email,
                style: GoogleFonts.tajawal(color: Colors.grey.shade600),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // =======================================================
      ],
    );
  }

  // ... (باقي دوال الـ build تبقى كما هي)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.tajawal(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      title: Text(title, style: GoogleFonts.tajawal()),
      leading: Icon(icon, color: AppColors.night_blue),
      trailing:
          trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
