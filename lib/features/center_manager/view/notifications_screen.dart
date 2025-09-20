
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:flutter_admain_center/data/models/center_maneger/notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // جلب الإشعارات عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationsBloc>().add(FetchNotifications());
      }
    });
    timeago.setLocaleMessages('ar', timeago.ArMessages());
  }

  Future<void> _refreshNotifications() async {
    context.read<NotificationsBloc>().add(FetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading && state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NotificationsStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'فشل تحميل الإشعارات'),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _refreshNotifications, child: const Text('إعادة المحاولة')),
                ],
              ),
            );
          }
          if (state.notifications.isEmpty) {
            return const Center(child: Text('لا توجد إشعارات لعرضها.'));
          }

          return RefreshIndicator(
            onRefresh: _refreshNotifications,
            child: ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _buildNotificationTile(context, notification);
              },
            ),
          );
        },
      ),
    );
  }

  // ✅ --- دالة بناء عنصر الإشعار (النسخة النهائية) ---
  Widget _buildNotificationTile(BuildContext context, NotificationModel notification) {
    final timeSince = timeago.format(DateTime.parse(notification.createdAt), locale: 'ar');
    final bool isApprovalRequest = notification.type == 'teacher_approval';

    return Container(
      color: notification.isRead ? Colors.white : Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.isRead ? Colors.grey.shade300 : Theme.of(context).primaryColor,
          child: Icon(
            isApprovalRequest ? Icons.person_add_alt_1_rounded : Icons.notifications_active,
            color: notification.isRead ? Colors.grey.shade600 : Colors.white,
          ),
        ),
        title: Text(notification.title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body, style: GoogleFonts.tajawal()),
            const SizedBox(height: 4),
            Text(timeSince, style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 12)),
            
            // ✅ عرض الأزرار فقط إذا كان طلب موافقة
            if (isApprovalRequest)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('رفض', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        context.read<NotificationsBloc>().add(
                          RejectTeacherRequest(notification.id, notification.teacherId!),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      child: const Text('قبول'),
                      onPressed: () {
                        context.read<NotificationsBloc>().add(
                          ApproveTeacherRequest(notification.id, notification.teacherId!),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
        onTap: () {
          // لا تفعل شيئاً عند الضغط إذا كان يحتوي على أزرار
          if (isApprovalRequest) return;

          if (!notification.isRead) {
            context.read<NotificationsBloc>().add(MarkNotificationAsRead(notification.id));
          }
        },
      ),
    );
  }
}
