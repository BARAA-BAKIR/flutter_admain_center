  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:timeago/timeago.dart' as timeago;
  import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
  import 'package:flutter_admain_center/data/models/center_maneger/notification_model.dart';

  class NotificationsScreen extends StatefulWidget {
    const NotificationsScreen({super.key});

    @override
    State<NotificationsScreen> createState() => _NotificationsScreenState();
  }

  class _NotificationsScreenState extends State<NotificationsScreen> {
    @override
    void initState() {
      super.initState();
      // ==================== هنا هو الإصلاح ====================
      // لا تستدعِ البلوك مباشرة هنا. قم بتأجيله.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // هذا الكود سيتم تنفيذه بعد أن يتم بناء الواجهة بالكامل
        // والـ context يكون جاهزاً تماماً للوصول إلى الـ Providers.
        if (mounted) {
          // التأكد من أن الويدجت لا تزال في الشجرة
          context.read<NotificationsBloc>().add(FetchNotifications());
        }
      });
      // =======================================================
      timeago.setLocaleMessages('ar', timeago.ArMessages());
    }

    @override
    Widget build(BuildContext context) {
      // ... (باقي الكود يبقى كما هو)
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'الإشعارات',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state.status == NotificationsStatus.loading &&
                state.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == NotificationsStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'فشل تحميل الإشعارات'),
              );
            }
            if (state.notifications.isEmpty) {
              return const Center(child: Text('لا توجد إشعارات لعرضها.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationsBloc>().add(FetchNotifications());
              },
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

    Widget _buildNotificationTile(
      BuildContext context,
      NotificationModel notification,
    ) {
      final timeSince = timeago.format(
        DateTime.parse(notification.createdAt),
        locale: 'ar',
      );

      // ✅ التحقق إذا كان الإشعار من نوع طلب موافقة
      final bool isApprovalRequest = notification.type == 'teacher_approval';

      return Container(
        color: notification.isRead ? Colors.white : Colors.blue.shade50,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                notification.isRead
                    ? Colors.grey.shade300
                    : Theme.of(context).primaryColor,
            child: Icon(
              isApprovalRequest
                  ? Icons.person_add_alt_1_rounded
                  : Icons.notifications_active,
              color: notification.isRead ? Colors.grey.shade600 : Colors.white,
            ),
          ),
          title: Text(
            notification.title,
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.body, style: GoogleFonts.tajawal()),
              const SizedBox(height: 4),
              Text(
                timeSince,
                style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 12),
              ),

              // ✅ عرض الأزرار فقط إذا كان الإشعار طلب موافقة ولم تتم قراءته بعد
              if (isApprovalRequest && !notification.isRead)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          'رفض',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          // ✅ ربط زر الرفض بالحدث الصحيح
                          context.read<NotificationsBloc>().add(
                            RejectTeacherRequest(
                              notification.id,
                              notification.teacherId!,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text('قبول'),
                        onPressed: () {
                          // ✅ ربط زر القبول بالحدث الصحيح
                          context.read<NotificationsBloc>().add(
                            ApproveTeacherRequest(
                              notification.id,
                              notification.teacherId!,
                            ),
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
              context.read<NotificationsBloc>().add(
                MarkNotificationAsRead(notification.id),
              );
            }
          },
        ),
      );
    }
  }
