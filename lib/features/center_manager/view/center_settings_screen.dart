
// In lib/features/center_manager/view/center_settings_screen.dart

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/edit_profile_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/notifications_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/change_password_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CenterSettingsScreen extends StatelessWidget {
  const CenterSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ====================  الكود الكامل والنهائي ====================
    // 1. احصل على حالة المصادقة الحالية مرة واحدة فقط عند بناء الواجهة
    final authState = context.read<AuthBloc>().state;

    // 2. تحقق من أن الحالة هي بالفعل AuthAuthenticated
    // إذا لم تكن كذلك، اعرض رسالة خطأ (هذه حالة استثنائية)
    if (authState is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(
          child: Text('خطأ: لا يمكن الوصول لهذه الشاشة بدون تسجيل الدخول.'),
        ),
      );
    }

    // 3. الآن لدينا بيانات المستخدم بأمان
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      // 4. بناء الواجهة مباشرة باستخدام بيانات المستخدم بدون BlocBuilder
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildUserProfileHeader(context, name: user.name, email: user.email),
          const SizedBox(height: 24),
          _buildSectionTitle('إدارة الحساب'),
          _buildSettingsCard(
            children: [
              _buildSettingsTile(
                context,
                title: 'تعديل الملف الشخصي',
                icon: Icons.edit_rounded,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (context) => ProfileBloc(
                                  authRepository:
                                      context.read<AuthRepository>(),
                                )..add(FetchProfile()),
                            child: const EditProfileScreen(),
                          ),
                    ),
                  );
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
          _buildSectionTitle('الإشعارات والموافقات'),
          _buildSettingsCard(
            children: [
              BlocBuilder<NotificationsBloc, NotificationsState>(
                builder: (context, notificationsState) {
                  return _buildSettingsTile(
                    context,
                    title: 'طلبات التسجيل المعلقة',
                    icon: Icons.pending_actions_rounded,
                    trailing: badges.Badge(
                      showBadge: notificationsState.unreadCount > 0,
                      badgeContent: Text(
                        notificationsState.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                    ),
                    onTap: () {
                      final notificationsBloc =
                          context.read<NotificationsBloc>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: notificationsBloc,
                                child: const NotificationsScreen(),
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
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
      ),
    );
  }

  // --- الدوال المساعدة ---

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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.tajawal(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
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
      ],
    );
  }

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
