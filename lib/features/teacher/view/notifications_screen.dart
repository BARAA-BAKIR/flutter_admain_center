// in lib/features/teacher/view/notifications_screen.dart
import 'package:flutter/material.dart';
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
    // توفير البلوك للشاشة
    return BlocProvider(
      create: (context) => NotificationBloc(
        teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
      )..add(FetchNotifications()), // طلب البيانات فوراً
      child: const NotificationView(),
    );
  }
}

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ar', timeago.ArMessages()); // تفعيل اللغة العربية للوقت
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<NotificationBloc>().add(FetchNotifications());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.status == NotificationStatus.loading && state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NotificationStatus.failure) {
            return Center(child: Text('فشل تحميل الإشعارات: ${state.errorMessage}'));
          }
          if (state.notifications.isEmpty) {
            return const Center(child: Text('لا توجد إشعارات حالياً.'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.notifications.length
                : state.notifications.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.notifications.length) {
                return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
              }
              final notification = state.notifications[index];
              return ListTile(
                leading: Icon(
                  notification.isRead ? Icons.notifications_off_outlined : Icons.notifications_active,
                  color: notification.isRead ? Colors.grey : AppColors.steel_blue,
                ),
                title: Text(
                  notification.title,
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(notification.body, style: GoogleFonts.tajawal()),
                trailing: Text(
                  timeago.format(notification.createdAt, locale: 'ar'),
                  style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  if (!notification.isRead) {
                    context.read<NotificationBloc>().add(MarkAsRead(notification.id));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
