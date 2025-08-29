// //   // import 'package:flutter/material.dart';
// //   // import 'package:flutter_bloc/flutter_bloc.dart';
// //   // import 'package:google_fonts/google_fonts.dart';
// //   // import 'package:timeago/timeago.dart' as timeago;
// //   // import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
// //   // import 'package:flutter_admain_center/data/models/center_maneger/notification_model.dart';

// //   // class NotificationsScreen extends StatefulWidget {
// //   //   const NotificationsScreen({super.key});

// //   //   @override
// //   //   State<NotificationsScreen> createState() => _NotificationsScreenState();
// //   // }

// //   // class _NotificationsScreenState extends State<NotificationsScreen> {
// //   //   @override
// //   //   void initState() {
// //   //     super.initState();
// //   //     // ==================== هنا هو الإصلاح ====================
// //   //     // لا تستدعِ البلوك مباشرة هنا. قم بتأجيله.
// //   //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //   //       // هذا الكود سيتم تنفيذه بعد أن يتم بناء الواجهة بالكامل
// //   //       // والـ context يكون جاهزاً تماماً للوصول إلى الـ Providers.
// //   //       if (mounted) {
// //   //         // التأكد من أن الويدجت لا تزال في الشجرة
// //   //         context.read<NotificationsBloc>().add(FetchNotifications());
// //   //       }
// //   //     });
// //   //     // =======================================================
// //   //     timeago.setLocaleMessages('ar', timeago.ArMessages());
// //   //   }

// //   //   @override
// //   //   Widget build(BuildContext context) {
// //   //     // ... (باقي الكود يبقى كما هو)
// //   //     return Scaffold(
// //   //       appBar: AppBar(
// //   //         title: Text(
// //   //           'الإشعارات',
// //   //           style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
// //   //         ),
// //   //       ),
// //   //       body: BlocBuilder<NotificationsBloc, NotificationsState>(
// //   //         builder: (context, state) {
// //   //           if (state.status == NotificationsStatus.loading &&
// //   //               state.notifications.isEmpty) {
// //   //             return const Center(child: CircularProgressIndicator());
// //   //           }
// //   //           if (state.status == NotificationsStatus.failure) {
// //   //             return Center(
// //   //               child: Text(state.errorMessage ?? 'فشل تحميل الإشعارات'),
// //   //             );
// //   //           }
// //   //           if (state.notifications.isEmpty) {
// //   //             return const Center(child: Text('لا توجد إشعارات لعرضها.'));
// //   //           }

// //   //           return RefreshIndicator(
// //   //             onRefresh: () async {
// //   //               context.read<NotificationsBloc>().add(FetchNotifications());
// //   //             },
// //   //             child: ListView.builder(
// //   //               itemCount: state.notifications.length,
// //   //               itemBuilder: (context, index) {
// //   //                 final notification = state.notifications[index];
// //   //                 return _buildNotificationTile(context, notification);
// //   //               },
// //   //             ),
// //   //           );
// //   //         },
// //   //       ),
// //   //     );
// //   //   }

// //   //   Widget _buildNotificationTile(
// //   //     BuildContext context,
// //   //     NotificationModel notification,
// //   //   ) {
// //   //     final timeSince = timeago.format(
// //   //       DateTime.parse(notification.createdAt),
// //   //       locale: 'ar',
// //   //     );

// //   //     // ✅ التحقق إذا كان الإشعار من نوع طلب موافقة
// //   //     final bool isApprovalRequest = notification.type == 'teacher_approval';

// //   //     return Container(
// //   //       color: notification.isRead ? Colors.white : Colors.blue.shade50,
// //   //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //   //       child: ListTile(
// //   //         leading: CircleAvatar(
// //   //           backgroundColor:
// //   //               notification.isRead
// //   //                   ? Colors.grey.shade300
// //   //                   : Theme.of(context).primaryColor,
// //   //           child: Icon(
// //   //             isApprovalRequest
// //   //                 ? Icons.person_add_alt_1_rounded
// //   //                 : Icons.notifications_active,
// //   //             color: notification.isRead ? Colors.grey.shade600 : Colors.white,
// //   //           ),
// //   //         ),
// //   //         title: Text(
// //   //           notification.title,
// //   //           style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
// //   //         ),
// //   //         subtitle: Column(
// //   //           crossAxisAlignment: CrossAxisAlignment.start,
// //   //           children: [
// //   //             Text(notification.body, style: GoogleFonts.tajawal()),
// //   //             const SizedBox(height: 4),
// //   //             Text(
// //   //               timeSince,
// //   //               style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 12),
// //   //             ),

// //   //             // ✅ عرض الأزرار فقط إذا كان الإشعار طلب موافقة ولم تتم قراءته بعد
// //   //             if (isApprovalRequest && !notification.isRead)
// //   //               Padding(
// //   //                 padding: const EdgeInsets.only(top: 8.0),
// //   //                 child: Row(
// //   //                   mainAxisAlignment: MainAxisAlignment.end,
// //   //                   children: [
// //   //                     TextButton(
// //   //                       child: const Text(
// //   //                         'رفض',
// //   //                         style: TextStyle(color: Colors.red),
// //   //                       ),
// //   //                       onPressed: () {
// //   //                         // ✅ ربط زر الرفض بالحدث الصحيح
// //   //                         context.read<NotificationsBloc>().add(
// //   //                           RejectTeacherRequest(
// //   //                             notification.id,
// //   //                             notification.teacherId!,
// //   //                           ),
// //   //                         );
// //   //                       },
// //   //                     ),
// //   //                     const SizedBox(width: 8),
// //   //                     ElevatedButton(
// //   //                       child: const Text('قبول'),
// //   //                       onPressed: () {
// //   //                         // ✅ ربط زر القبول بالحدث الصحيح
// //   //                         context.read<NotificationsBloc>().add(
// //   //                           ApproveTeacherRequest(
// //   //                             notification.id,
// //   //                             notification.teacherId!,
// //   //                           ),
// //   //                         );
// //   //                       },
// //   //                     ),
// //   //                   ],
// //   //                 ),
// //   //               ),
// //   //           ],
// //   //         ),
// //   //         onTap: () {
// //   //           // لا تفعل شيئاً عند الضغط إذا كان يحتوي على أزرار
// //   //           if (isApprovalRequest) return;

// //   //           if (!notification.isRead) {
// //   //             context.read<NotificationsBloc>().add(
// //   //               MarkNotificationAsRead(notification.id),
// //   //             );
// //   //           }
// //   //         },
// //   //       ),
// //   //     );
// //   //   }
// //   // }import 'package:flutter/material.dart';
// //   //تصليح بالنسبة لهي لازمimport 'package:bloc/bloc.dart';
// // import 'package:equatable/equatable.dart';
// // import 'package:flutter_admain_center/data/models/center_maneger/notification_model.dart';
// // import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';

// // part 'notifications_event.dart';
// // part 'notifications_state.dart';

// // class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
// //   final NotificationsRepository _notificationsRepository;

// //   NotificationsBloc({required NotificationsRepository notificationsRepository})
// //       : _notificationsRepository = notificationsRepository,
// //         super(const NotificationsState()) {
// //     on<FetchUnreadCount>(_onFetchUnreadCount);
// //     on<FetchNotifications>(_onFetchNotifications);
// //     on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
// //      on<ApproveTeacherRequest>(_onApproveTeacherRequest);
// //     on<RejectTeacherRequest>(_onRejectTeacherRequest);

// //   }
// // Future<void> _onApproveTeacherRequest(
// //     ApproveTeacherRequest event, Emitter<NotificationsState> emit
// //   ) async {
// //     // أضف حالة تحميل مؤقتة إذا أردت
// //     final result = await _notificationsRepository.approveTeacher(event.teacherId);
// //     result.fold(
// //       (failure) {  print("❌ FAILED TO APPROVE TEACHER: ${failure.message}");},
// //       (_) {print("✅ SUCCESSFULLY APPROVED TEACHER on server.");
// //         // عند النجاح، قم بتحديث القائمة لإزالة الإشعار
// //         final updatedList = state.notifications.where((n) => n.id != event.notificationId).toList();
// //         emit(state.copyWith(notifications: updatedList));
// //         // ثم قم بتحديث العدد
// //         add(FetchUnreadCount());
// //       },
// //     );
// //   }

// //   // دالة لمعالجة حدث الرفض
// //   Future<void> _onRejectTeacherRequest(
// //     RejectTeacherRequest event, Emitter<NotificationsState> emit
// //   ) async {
// //     // أضف حالة تحميل مؤقتة إذا أردت
// //     final result = await _notificationsRepository.rejectTeacher(event.teacherId);
// //     result.fold(
// //       (failure) {  print("❌ FAILED TO REJECT TEACHER: ${failure.message}"); },
// //       (_) { print("✅ SUCCESSFULLY REJECTED TEACHER on server.");
// //         // عند النجاح، قم بتحديث القائمة لإزالة الإشعار
// //         final updatedList = state.notifications.where((n) => n.id != event.notificationId).toList();
// //         emit(state.copyWith(notifications: updatedList));
// //         // ثم قم بتحديث العدد
// //         add(FetchUnreadCount());
// //       },
// //     );
// //   }

// //   Future<void> _onFetchUnreadCount(
// //     FetchUnreadCount event, Emitter<NotificationsState> emit
// //   ) async {
// //     final result = await _notificationsRepository.getUnreadCount();
// //     result.fold(
// //       (failure) { /* يمكنك معالجة الخطأ هنا */ },
// //       (count) => emit(state.copyWith(unreadCount: count)),
// //     );
// //   }

// //   Future<void> _onFetchNotifications(
// //     FetchNotifications event, Emitter<NotificationsState> emit
// //   ) async {
// //     emit(state.copyWith(status: NotificationsStatus.loading));
// //     final result = await _notificationsRepository.getNotifications();
// //     result.fold(
// //       (failure) => emit(state.copyWith(status: NotificationsStatus.failure, errorMessage: failure.message)),
// //       (notifications) => emit(state.copyWith(status: NotificationsStatus.success, notifications: notifications)),
// //     );
// //   }

// //   Future<void> _onMarkNotificationAsRead(
// //     MarkNotificationAsRead event, Emitter<NotificationsState> emit
// //   ) async {
// //     // أولاً، نحدث الحالة في الواجهة فوراً لتجربة مستخدم أفضل
// //     final updatedList = state.notifications.map((n) {
// //       return n.id == event.notificationId ? n.copyWith(isRead: true) : n;
// //     }).toList();
// //     emit(state.copyWith(notifications: updatedList));

// //     // ثانياً، نرسل الطلب إلى الخادم في الخلفية
// //     final result = await _notificationsRepository.markAsRead(event.notificationId);
// //     result.fold(
// //       (failure) { /* يمكنك معالجة الخطأ هنا إذا فشل الطلب */ },
// //       (_) {
// //         // ثالثاً، نعيد جلب العدد غير المقروء لتحديث الأيقونة في AppBar
// //         add(FetchUnreadCount());
// //       },
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:timeago/timeago.dart' as timeago;


// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         context.read<NotificationsBloc>().add(FetchNotifications());
//       }
//     });
//     timeago.setLocaleMessages('ar', timeago.ArMessages());
//   }

//   Future<void> _refreshNotifications() async {
//     context.read<NotificationsBloc>().add(FetchNotifications());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الإشعارات', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//       ),
//       body: BlocBuilder<NotificationsBloc, NotificationsState>(
//         builder: (context, state) {
//           if (state.status == NotificationsStatus.loading && state.notifications.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state.status == NotificationsStatus.failure) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(state.errorMessage ?? 'فشل تحميل الإشعارات'),
//                   const SizedBox(height: 10),
//                   ElevatedButton(onPressed: _refreshNotifications, child: const Text('إعادة المحاولة')),
//                 ],
//               ),
//             );
//           }
//           if (state.notifications.isEmpty) {
//             return const Center(child: Text('لا توجد إشعارات لعرضها.'));
//           }

//           return RefreshIndicator(
//             onRefresh: _refreshNotifications,
//             child: ListView.builder(
//               itemCount: state.notifications.length,
//               itemBuilder: (context, index) {
//                 final notification = state.notifications[index];
//                 final timeSince = timeago.format(
//                   DateTime.parse(notification.createdAt),
//                   locale: 'ar',
//                 );
//                 final bool isApprovalRequest = notification.type == 'teacher_approval';

//                 return Container(
//                   color: notification.isRead ? Colors.white : Colors.blue.shade50,
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: notification.isRead
//                           ? Colors.grey.shade300
//                           : Theme.of(context).primaryColor,
//                       child: Icon(
//                         isApprovalRequest
//                             ? Icons.person_add_alt_1_rounded
//                             : Icons.notifications_active,
//                         color: notification.isRead ? Colors.grey.shade600 : Colors.white,
//                       ),
//                     ),
//                     title: Text(
//                       notification.title,
//                       style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(notification.body, style: GoogleFonts.tajawal()),
//                         const SizedBox(height: 4),
//                         Text(
//                           timeSince,
//                           style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 12),
//                         ),
//                         if (isApprovalRequest && !notification.isRead)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 TextButton(
//                                   child: const Text(
//                                     'رفض',
//                                     style: TextStyle(color: Colors.red),
//                                   ),
//                                   onPressed: () {
//                                     context.read<NotificationsBloc>().add(
//                                       RejectTeacherRequest(
//                                         notification.id,
//                                         notification.teacherId!,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 const SizedBox(width: 8),
//                                 ElevatedButton(
//                                   child: const Text('قبول'),
//                                   onPressed: () {
//                                     context.read<NotificationsBloc>().add(
//                                       ApproveTeacherRequest(
//                                         notification.id,
//                                         notification.teacherId!,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                     onTap: () {
//                       if (isApprovalRequest) return;
//                       if (!notification.isRead) {
//                         context.read<NotificationsBloc>().add(
//                           MarkNotificationAsRead(notification.id),
//                         );
//                       }
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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
