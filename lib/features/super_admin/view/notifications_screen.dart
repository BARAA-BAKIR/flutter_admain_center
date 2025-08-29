import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_admain_center/features/super_admin/bloc/notifications_bloc/notifications_bloc.dart' as SuperAdminBloc;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    context.read<SuperAdminBloc.NotificationsBloc>().add(SuperAdminBloc.LoadNotificationDetails());
  }

  Future<void> _refreshNotifications() async {
    context.read<SuperAdminBloc.NotificationsBloc>().add(SuperAdminBloc.LoadNotificationDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلبات التسجيل المعلقة', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<SuperAdminBloc.NotificationsBloc, SuperAdminBloc.NotificationsState>(
        listener: (context, state) {
          if (state is SuperAdminBloc.NotificationsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ: ${state.message}'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is SuperAdminBloc.NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SuperAdminBloc.NotificationsError && state is! SuperAdminBloc.NotificationsDetailsLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('فشل تحميل الطلبات: ${state.message}'),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _refreshNotifications, child: const Text('إعادة المحاولة')),
                ],
              ),
            );
          }

          if (state is SuperAdminBloc.NotificationsDetailsLoaded) {
            if (state.notifications.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refreshNotifications,
                child: ListView(children: const [Center(child: Text('لا توجد طلبات تسجيل معلقة حالياً.'))]),
              );
            }
            
            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  final requestData = notification.body;
                  final userId = requestData['user_id'] as int?;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person_add_alt_1_rounded)),
                        title: Text(requestData['user_name']?.toString() ?? 'اسم غير متوفر', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'طلب صلاحية: ${requestData['requested_role'] ?? 'غير محدد'}\n${timeago.format(notification.createdAt, locale: 'ar')}',
                          style: GoogleFonts.tajawal(),
                        ),
                        trailing: userId == null ? null : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: Colors.green, size: 30),
                              onPressed: () {
                                context.read<SuperAdminBloc.NotificationsBloc>().add(SuperAdminBloc.ApproveRequest(notificationId: notification.id, userId: userId));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red, size: 30),
                              onPressed: () {
                                context.read<SuperAdminBloc.NotificationsBloc>().add(SuperAdminBloc.RejectRequest(notificationId: notification.id, userId: userId));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: _refreshNotifications,
              child: const Text('تحميل الطلبات'),
            ),
          );
        },
      ),
    );
  }
}
