// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/notifications_bloc/notifications_bloc.dart' as SuperAdminBloc;
// import 'package:flutter_admain_center/features/super_admin/view/notifications_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/settings_screen.dart'; // شاشة الإعدادات الجديدة
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:badges/badges.dart' as badges;

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final TabBar? bottom; // لكي نتمكن من إضافة TabBar

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.bottom,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       // ✅ 1. إزالة زر الرجوع التلقائي
//       automaticallyImplyLeading: false,
//       backgroundColor: Colors.white,
//       elevation: 1,
//       // ✅ 2. العنوان الديناميكي
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
       
//         children: [
//           Padding(
//           padding: const EdgeInsets.only(right: 8.0, left: 8.0),
//           child: Image.asset('assets/image.png', height: 60, width: 60),
//         ),
//           Text(
//             title,
//             style: GoogleFonts.tajawal(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
        
//       // ),
//       // actions: [
//         // ✅ 3. أيقونة الإشعارات مع عداد
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             BlocBuilder<SuperAdminBloc.NotificationsBloc, SuperAdminBloc.NotificationsState>(
//               builder: (context, state) {
//                 int count = 0;
//                 if (state is SuperAdminBloc.NotificationsCountLoaded) {
//                   count = state.unreadCount;
//                 }
//                 return IconButton(
//                   icon: badges.Badge(
//                     showBadge: count > 0,
//                     badgeContent: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
//                     child: const Icon(Icons.notifications_rounded, color: Colors.black54),
//                   ),
//                   onPressed: () {
//                     // فتح شاشة الطلبات المعلقة
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const NotificationsScreen()),
//                     );
//                   },
//                 );
//               },
//             ),
//         // ✅ 4. أيقونة الإعدادات
//         IconButton(
//           icon: const Icon(Icons.settings_rounded, color: Colors.black54),
//           onPressed: () {
//             // فتح شاشة الإعدادات
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const SettingsScreen()),
//             );
//           },
//         ),
//           ],
//         ),
//         // ✅ 5. الشعار الثابت
//         // Padding(
//         //   padding: const EdgeInsets.only(right: 8.0, left: 8.0),
//         //   child: Image.asset('assets/image.png', height: 50, width: 50),
//         // ),
//       // ],
//       ],),
//       bottom: bottom, // ✅ 6. إضافة الـ TabBar إذا تم تمريره
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
// }
