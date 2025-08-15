// // import 'package:flutter/material.dart';
// // import 'package:flutter_admain_center/features/center_manager/bloc/add_halaqa_bloc/add_halaqa_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/view/add_halaqa_screen.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:flutter_admain_center/core/constants/app_colors.dart';
// // import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

// // // --- استيراد البلوكات والأقسام اللازمة ---
// // import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
// // import 'tabs/halaqas_tab.dart';
// // import 'tabs/teachers_tab.dart'; // <-- استيراد قسم الأساتذة الفعلي

// // class StaffScreen extends StatefulWidget {
// //   const StaffScreen({super.key});

// //   @override
// //   State<StaffScreen> createState() => _StaffScreenState();
// // }

// // class _StaffScreenState extends State<StaffScreen> {
// //   // دالة لفتح شاشة إضافة الحلقة
// //   void _navigateToAddHalaqa() {
// //     // ✅ 3. إنشاء البلوك هنا باستخدام الـ context الخاص بـ StaffScreen
// //     //    هذا الـ context مضمون 100% أنه يحتوي على CenterManagerRepository
// //     final addHalaqaBloc = AddHalaqaBloc(
// //       repository: context.read<CenterManagerRepository>(),
// //     );

// //     Navigator.of(context)
// //         .push<bool>(
// //           MaterialPageRoute(
// //             builder:
// //                 (_) => BlocProvider.value(
// //                   // ✅ 4. استخدم BlocProvider.value
// //                   value: addHalaqaBloc, // مرر البلوك الذي أنشأته للتو
// //                   child: const AddHalaqaScreen(),
// //                 ),
// //           ),
// //         )
// //         .then((result) {
// //           // ✅ 5. التعامل مع النتيجة بعد العودة من الشاشة
// //           if (result == true && mounted) {
// //             // أعد جلب بيانات الحلقات إذا نجحت الإضافة
// //             context.read<HalaqasBloc>().add(const FetchHalaqas());
// //           }
// //         });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // استخدام MultiBlocProvider لتوفير كل البلوكات اللازمة لهذه الشاشة
// //     return MultiBlocProvider(
// //       providers: [
// //         // --- توفير البلوك الخاص بالحلقات ---
// //         BlocProvider(
// //           create:
// //               (context) => HalaqasBloc(
// //                 centerManagerRepository:
// //                     context.read<CenterManagerRepository>(),
// //               )..add(const FetchHalaqas()), // طلب بيانات الحلقات فوراً
// //         ),

// //         // ==================== هنا هو الإصلاح ====================
// //         // --- توفير البلوك الخاص بالأساتذة ---
// //         BlocProvider(
// //           create:
// //               (context) => TeachersBloc(
// //                 centerManagerRepository:
// //                     context.read<CenterManagerRepository>(),
// //               )..add(const FetchTeachers()), // طلب بيانات الأساتذة فوراً
// //         ),
// //         // =======================================================
// //       ],
// //       child: DefaultTabController(
// //         length: 2,
// //         child: Scaffold(
// //           backgroundColor: Colors.grey.shade100,
// //           appBar: AppBar(
// //             title: Text(
// //               'الكادر التعليمي',
// //               style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
// //             ),
// //             backgroundColor: Colors.grey.shade100,
// //             elevation: 0,
// //             bottom: TabBar(
// //               labelStyle: GoogleFonts.tajawal(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 16,
// //               ),
// //               unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 16),
// //               labelColor: AppColors.steel_blue,
// //               unselectedLabelColor: Colors.grey.shade600,
// //               indicatorColor: AppColors.steel_blue,
// //               indicatorWeight: 3,
// //               tabs: const [Tab(text: 'الحلقات'), Tab(text: 'الأساتذة')],
// //             ),
// //           ),
// //           body: const TabBarView(
// //             children: [
// //               // --- عرض الأقسام الفعلية ---
// //               HalaqasTab(),
// //               TeachersTab(), // <-- استبدال الـ Placeholder بالويدجت الحقيقية
// //             ],
// //           ),

// //           // lib/features/center_manager/view/staff_screen.dart
// //           floatingActionButton: FloatingActionButton(
// //             onPressed: _navigateToAddHalaqa,
// //             backgroundColor: AppColors.steel_blue,
// //             child: const Icon(Icons.add),
// //           ),
// //           // floatingActionButton: FloatingActionButton(
// //           //   onPressed: () async {
// //           //     // ننتظر نتيجة شاشة الإضافة
// //           //     final newTeacher = await Navigator.of(context).push<Teacher>(
// //           //       MaterialPageRoute(
// //           //         builder:
// //           //             (_) => BlocProvider(
// //           //               // إنشاء بلوك الإضافة وتوفيره للشاشة الجديدة
// //           //               create:
// //           //                   (context) => AddTeacherBloc(
// //           //                     repository:
// //           //                         context.read<CenterManagerRepository>(),
// //           //                   ),
// //           //               child: const AddTeacherScreen(),
// //           //             ),
// //           //       ),
// //           //     );

// //           //     // إذا عادت الشاشة بأستاذ جديد، قم بتحديث القائمة
// //           //     if (newTeacher != null && context.mounted) {
// //           //       context.read<TeachersBloc>().add(
// //           //         AddNewTeacherToList(newTeacher),
// //           //       );
// //           //     }
// //           //   },
// //           //   backgroundColor: AppColors.steel_blue,
// //           //   child: const Icon(Icons.person_add_alt_1_rounded),
// //           // ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/data/models/center_maneger/teacher_model.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/add_halaqa_bloc/add_halaqa_bloc.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/add_teacher_bloc/add_teacher_bloc.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
// import 'package:flutter_admain_center/features/center_manager/view/add_halaqa_screen.dart';
// import 'package:flutter_admain_center/features/center_manager/view/add_teacher_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
// import 'tabs/halaqas_tab.dart';
// import 'tabs/teachers_tab.dart';

// //  تحويلها إلى StatefulWidget لإدارة TabController
// class StaffScreen extends StatefulWidget {
//   const StaffScreen({super.key});

//   @override
//   State<StaffScreen> createState() => _StaffScreenState();
// }

// class _StaffScreenState extends State<StaffScreen> with SingleTickerProviderStateMixin {
//   //  تعريف TabController
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     //  تهيئة TabController وإضافة مستمع (listener)
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       //  إعادة بناء الواجهة عند تغيير الـ Tab لإظهار الزر الصحيح
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   //  دالة لفتح شاشة إضافة حلقة
//   void _navigateToAddHalaqa() async {
//     final result = await Navigator.of(context).push<bool>(
//       MaterialPageRoute(
//         builder: (_) => BlocProvider(
//           create: (context) => AddHalaqaBloc(repository: context.read<CenterManagerRepository>()),
//           child: const AddHalaqaScreen(),
//         ),
//       ),
//     );
//     if (result == true && mounted) {
//       context.read<HalaqasBloc>().add(const FetchHalaqas());
//     }
//   }

//   //  دالة لفتح شاشة إضافة أستاذ
//   void _navigateToAddTeacher() async {
//     final newTeacher = await Navigator.of(context).push<Teacher>(
//       MaterialPageRoute(
//         builder: (_) => BlocProvider(
//           create: (context) => AddTeacherBloc(repository: context.read<CenterManagerRepository>()),
//           child: const AddTeacherScreen(),
//         ),
//       ),
//     );
//     if (newTeacher != null && mounted) {
//       context.read<TeachersBloc>().add(AddNewTeacherToList(newTeacher));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => HalaqasBloc(centerManagerRepository: context.read<CenterManagerRepository>())..add(const FetchHalaqas()),
//         ),
//         BlocProvider(
//           create: (context) => TeachersBloc(centerManagerRepository: context.read<CenterManagerRepository>())..add(const FetchTeachers()),
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar: AppBar(
//           title: Text('الكادر التعليمي', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//           backgroundColor: Colors.grey.shade100,
//           elevation: 0,
//           bottom: TabBar(
//             controller: _tabController, //  ربط الـ TabBar بالـ Controller
//             labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
//             unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 16),
//             labelColor: AppColors.steel_blue,
//             unselectedLabelColor: Colors.grey.shade600,
//             indicatorColor: AppColors.steel_blue,
//             indicatorWeight: 3,
//             tabs: const [
//               Tab(text: 'الحلقات'),
//               Tab(text: 'الأساتذة'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController, //  ربط الـ TabBarView بالـ Controller
//           children: const [
//             HalaqasTab(),
//             TeachersTab(),
//           ],
//         ),
//         //  الآن الزر سيتغير بناءً على الـ Tab المحدد
//         floatingActionButton: _tabController.index == 0
//             ? FloatingActionButton.extended(
//                 onPressed: _navigateToAddHalaqa,
//                 label: const Text('إضافة حلقة'),
//                 icon: const Icon(Icons.add_circle_outline),
//                 backgroundColor: AppColors.teal_blue,
//               )
//             : FloatingActionButton.extended(
//                 onPressed: _navigateToAddTeacher,
//                 label: const Text('إضافة أستاذ'),
//                 icon: const Icon(Icons.person_add_alt_1),
//                 backgroundColor: AppColors.steel_blue,
//               ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_halaqa_bloc/add_halaqa_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_teacher_bloc/add_teacher_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/add_halaqa_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/add_teacher_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'tabs/halaqas_tab.dart';
import 'tabs/teachers_tab.dart';

//  العودة إلى StatelessWidget لأنه لا توجد حالة محلية لإدارتها
class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  //  دالة لفتح شاشة إضافة حلقة
  void _navigateToAddHalaqa(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AddHalaqaBloc(repository: context.read<CenterManagerRepository>()),
          child: const AddHalaqaScreen(),
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<HalaqasBloc>().add(const FetchHalaqas());
    }
  }

  //  دالة لفتح شاشة إضافة أستاذ
  void _navigateToAddTeacher(BuildContext context) async {
    final newTeacher = await Navigator.of(context).push<Teacher>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AddTeacherBloc(repository: context.read<CenterManagerRepository>()),
          child: const AddTeacherScreen(),
        ),
      ),
    );
    if (newTeacher != null && context.mounted) {
      context.read<TeachersBloc>().add(AddNewTeacherToList(newTeacher));
    }
  }

  @override
  Widget build(BuildContext context) {
    //  استخدام DefaultTabController هو الطريقة الصحيحة هنا
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          //  إزالة title من هنا لأن كل تاب له عنوانه الخاص
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          //  الـ TabBar هو الـ bottom الخاص بالـ AppBar
          bottom: TabBar(
            labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 16),
            labelColor: AppColors.steel_blue,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: AppColors.steel_blue,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'الحلقات'),
              Tab(text: 'الأساتذة'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HalaqasTab(),
            TeachersTab(),
          ],
        ),
        // ==================== هنا هو الإصلاح الكامل والنهائي ====================
        //  استخدام Builder للحصول على سياق جديد يمكنه الوصول إلى DefaultTabController
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            //  الحصول على الـ index الخاص بالـ Tab الحالي
            final tabIndex = DefaultTabController.of(context).index;

            //  عرض الزر المناسب بناءً على الـ index
            return tabIndex == 0
                ? FloatingActionButton.extended(
                    onPressed: () => _navigateToAddHalaqa(context),
                    label: const Text('إضافة حلقة'),
                    icon: const Icon(Icons.add_circle_outline),
                    backgroundColor: AppColors.teal_blue,
                  )
                : FloatingActionButton.extended(
                    onPressed: () => _navigateToAddTeacher(context),
                    label: const Text('إضافة أستاذ'),
                    icon: const Icon(Icons.person_add_alt_1),
                    backgroundColor: AppColors.steel_blue,
                  );
          },
        ),
        // ====================================================================
      ),
    );
  }
}
