import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/teacher/notification_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/teacher/bloc/notifications/notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نقوم بضبط اللغة العربية لـ timeago
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    return BlocProvider(
      create: (context) => NotificationsBloc(
        teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
      )..add(FetchNotifications()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('الإشعارات', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.steel_blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state.status == NotificationsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == NotificationsStatus.failure) {
              return Center(child: Text('فشل تحميل الإشعارات: ${state.errorMessage}'));
            }
            if (state.notifications.isEmpty) {
              return const Center(child: Text('لا توجد إشعارات حالياً.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationsBloc>().add(FetchNotifications());
              },
              child: ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _buildNotificationTile(notification);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    final notificationTime = notification.createdAt;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isRead ? Colors.grey.shade300 : AppColors.steel_blue,
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.isRead ? Colors.grey.shade200 : AppColors.light_sky_blue,
          child: const Icon(Icons.notifications_active, color: AppColors.steel_blue),
        ),
        title: Text(notification.title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        subtitle: Text(notification.body, style: GoogleFonts.tajawal()),
        trailing: Text(
          timeago.format(notificationTime, locale: 'ar'),
          style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey.shade600),
        ),
        onTap: () {
          // TODO: يمكنك هنا تعليم الإشعار كمقروء في الخادم
        },
      ),
    );
  }
}
