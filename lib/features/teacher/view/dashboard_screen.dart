// import 'dart:developer';

// import 'package:flutter/material.dart';
// //import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
// import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/dashboard/dashboard_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:fl_chart/fl_chart.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   // متغير لتتبع ما إذا كان التحميل الأولي قد تم
//   bool _initialLoadTriggered = false;

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<HalaqaBloc, HalaqaState>(
//       // الاستماع فقط عند تغيير حالة الحلقة من null إلى قيمة
//       listenWhen:
//           (previous, current) =>
//               previous.halaqa == null && current.halaqa != null,
//       listener: (context, state) {
//         final halaqaId = state.halaqa?.idhalaqa;
//         if (halaqaId != null && !_initialLoadTriggered) {
//           log(
//             "✅ [UI] HalaqaBloc: تم تحميل بيانات الحلقة. إرسال حدث تحميل لوحة التحكم لـ halaqaId = $halaqaId",
//           );
//           context.read<DashboardBloc>().add(
//             LoadDashboardData(halaqaId: halaqaId),
//           );
//           _initialLoadTriggered = true; // نمنع إرسال الحدث مرة أخرى
//         }
//       },
//       child: BlocConsumer<DashboardBloc, DashboardState>(
//         // 1. الاستماع فقط لتغيرات حالة المزامنة
//         listenWhen:
//             (previous, current) => previous.syncStatus != current.syncStatus,
//         listener: (context, state) {
//           // لا تعرض أي شيء أثناء التحميل
//           if (state.syncStatus == SyncStatus.syncing) return;

//           // عند النجاح
//           if (state.syncStatus == SyncStatus.success) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: const Text('تمت مزامنة البيانات بنجاح!'),
//                   backgroundColor: Colors.green,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   margin: const EdgeInsets.only(
//                     bottom: 40.0,
//                     left: 16.0,
//                     right: 16.0,
//                   ),
//                 ),
//               );
//           }
//           // عند الفشل
//           else if (state.syncStatus == SyncStatus.failure) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     'فشل المزامنة: ${state.syncError ?? "خطأ غير معروف"}',
//                   ),
//                   backgroundColor: Colors.red,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   margin: const EdgeInsets.only(
//                     bottom: 40.0,
//                     left: 16.0,
//                     right: 16.0,
//                   ),
//                 ),
//               );
//           }
//         },
//         // 2. بناء الواجهة بناءً على حالة تحميل البيانات الرئيسية
//         builder: (context, dashboardState) {
//           // هذا الجزء هو الـ body الأصلي للشاشة
//           return Scaffold(
//             backgroundColor: Colors.grey.shade100,
//             appBar: AppBar(
//               title: Text(
//                 'لوحة التحكم',
//                 style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//               ),
//               backgroundColor: AppColors.steel_blue,
//               foregroundColor: Colors.white,
//               centerTitle: true,
//             ),
//             body: _buildBody(
//               context,
//               dashboardState,
//             ), // استخراج الـ body في دالة منفصلة
//           );
//         },
//       ),
//     );
//   }

//   // دالة منفصلة لبناء محتوى الشاشة لتنظيم الكود
//   Widget _buildBody(BuildContext context, DashboardState dashboardState) {
//     if (dashboardState.status == DashboardStatus.loading &&
//         dashboardState.dashboardData == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (dashboardState.status == DashboardStatus.failure) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(dashboardState.error ?? 'حدث خطأ غير متوقع'),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 final halaqaId =
//                     context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
//                 if (halaqaId != null) {
//                   context.read<DashboardBloc>().add(
//                     LoadDashboardData(halaqaId: halaqaId),
//                   );
//                 }
//               },
//               child: const Text('إعادة المحاولة'),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: () async {
//         final halaqaId = context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
//         log("🔁 [UI] تم سحب التحديث - halaqaId = $halaqaId");
//         if (halaqaId != null) {
//           context.read<DashboardBloc>().add(
//             LoadDashboardData(halaqaId: halaqaId),
//           );
//         }
//       },
//       child: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           _buildSyncCard(context), // هذا الكود لم يتغير
//           const SizedBox(height: 16),
//           _buildSummaryCard(dashboardState.dashboardData?.summary),
//           const SizedBox(height: 16),
//           _buildSectionTitle('بحاجة لمتابعة ⚠️'),
//           _buildNeedsAttentionCard(
//             dashboardState.dashboardData?.needsAttention,
//           ),
//           const SizedBox(height: 16),
//           _buildSectionTitle('أفضل الطلاب هذا الأسبوع 🏆'),
//           _buildTopStudentsCard(dashboardState.dashboardData?.topStudents),
//           const SizedBox(height: 16),
//           _buildSectionTitle('إحصائيات الحضور (آخر 30 يوم)'),
//           _buildAttendanceChartCard(
//             dashboardState.dashboardData?.attendanceChart,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         title,
//         style: GoogleFonts.tajawal(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: AppColors.night_blue,
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryCard(DashboardSummary? summary) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildSummaryItem(
//               'الحضور اليوم',
//               summary?.presentToday.toString() ?? '...',
//               Icons.check_circle,
//               AppColors.teal_blue,
//             ),
//             _buildSummaryItem(
//               'الغياب اليوم',
//               summary?.absentToday.toString() ?? '...',
//               Icons.cancel,
//               Colors.red.shade600,
//             ),
//             _buildSummaryItem(
//               'تم تقييمهم',
//               summary?.evaluatedToday.toString() ?? '...',
//               Icons.fact_check,
//               AppColors.golden_orange,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryItem(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 32),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: GoogleFonts.tajawal(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.night_blue,
//           ),
//         ),
//         Text(
//           title,
//           style: GoogleFonts.tajawal(fontSize: 14, color: Colors.grey.shade600),
//         ),
//       ],
//     );
//   }

//   Widget _buildNeedsAttentionCard(List<NeedsAttentionStudent>? students) {
//     if (students == null || students.isEmpty) {
//       return const Card(
//         child: ListTile(title: Text('لا يوجد طلاب بحاجة لمتابعة خاصة حالياً.')),
//       );
//     }
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children:
//               students
//                   .map(
//                     (student) => ListTile(
//                       leading: const Icon(
//                         Icons.person_pin,
//                         color: Colors.orange,
//                       ),
//                       title: Text(student.name, style: GoogleFonts.tajawal()),
//                       subtitle: Text(
//                         'التقدير السابق: ${student.lastEvaluation}',
//                         style: GoogleFonts.tajawal(),
//                       ),
//                     ),
//                   )
//                   .toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopStudentsCard(List<TopStudent>? students) {
//     if (students == null || students.isEmpty) {
//       return const Card(
//         child: ListTile(title: Text('لا توجد بيانات كافية لعرض أفضل الطلاب.')),
//       );
//     }
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(students.length, (index) {
//             return _buildTopStudentItem(students[index].name, index + 1);
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopStudentItem(String name, int rank) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 30,
//           backgroundColor: AppColors.light_sky_blue,
//           child: Text(
//             rank.toString(),
//             style: const TextStyle(
//               fontSize: 24,
//               color: AppColors.steel_blue,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(name, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildAttendanceChartCard(AttendanceChartData? data) {
//     final double present = data?.present.toDouble() ?? 0;
//     final double absent = data?.absent.toDouble() ?? 0;
//     final bool hasData = present > 0 || absent > 0;

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SizedBox(
//           height: 200,
//           child:
//               hasData
//                   ? PieChart(
//                     PieChartData(
//                       sections: [
//                         PieChartSectionData(
//                           color: AppColors.teal_blue,
//                           value: present,
//                           title:
//                               '${((present / (present + absent)) * 100).toStringAsFixed(0)}%',
//                           radius: 80,
//                           titleStyle: GoogleFonts.tajawal(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         PieChartSectionData(
//                           color: Colors.red.shade400,
//                           value: absent,
//                           title:
//                               '${((absent / (present + absent)) * 100).toStringAsFixed(0)}%',
//                           radius: 80,
//                           titleStyle: GoogleFonts.tajawal(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                       sectionsSpace: 2,
//                       centerSpaceRadius: 40,
//                     ),
//                   )
//                   : const Center(
//                     child: Text(
//                       'لا توجد بيانات حضور كافية لعرض الرسم البياني.',
//                     ),
//                   ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSyncCard(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shadowColor: AppColors.dark_teal_blue.withOpacity(0.5),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       color: AppColors.dark_teal_blue,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Icon(Icons.cloud_sync_rounded, color: Colors.white, size: 40),
//             const SizedBox(height: 8),
//             Text(
//               'مزامنة البيانات مع السيرفر',
//               style: GoogleFonts.tajawal(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'اضغط هنا لترحيل كل البيانات المحفوظة محلياً إلى السيرفر.',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 14),
//             ),
//             const SizedBox(height: 16),
//             BlocBuilder<DashboardBloc, DashboardState>(
//               buildWhen:
//                   (previous, current) =>
//                       previous.syncStatus != current.syncStatus,
//               builder: (context, dashboardState) {
//                 if (dashboardState.syncStatus == SyncStatus.syncing) {
//                   return const CircularProgressIndicator(color: Colors.white);
//                 }
//                 return ElevatedButton.icon(
//                   onPressed: () {
//                     final halaqaId =
//                         context.read<HalaqaBloc>().state.halaqa?.idhalaqa;

//                     print("☁️ [UI] بدأ ترحيل البيانات - halaqaId = $halaqaId");
//                     if (halaqaId != null) {
//                       // ✅ أرسل الحدث SyncAllDataRequested فقط
//                       context.read<DashboardBloc>().add(
//                         SyncAllDataRequested(halaqaId),
//                       );
//                       // ❌ حذف Future.delayed
//                     }
//                   },
//                   icon: const Icon(Icons.upload_rounded),
//                   label: Text('بدء الترحيل', style: GoogleFonts.tajawal()),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.golden_orange,
//                     foregroundColor: Colors.white,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
import 'package:flutter_admain_center/features/teacher/bloc/dashboard/dashboard_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم BlocConsumer للاستماع للرسائل (SnackBar) وبناء الواجهة
    return BlocConsumer<DashboardBloc, DashboardState>(
      // 1. الاستماع فقط لتغيرات حالة المزامنة لعرض SnackBar
      listenWhen:
          (previous, current) => previous.syncStatus != current.syncStatus,
      listener: (context, state) {
        // لا تعرض أي شيء أثناء التحميل
        if (state.syncStatus == SyncStatus.syncing) return;

        if (state.syncStatus == SyncStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text('تمت مزامنة البيانات بنجاح!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.only(
                  bottom: 40.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
            );
        } else if (state.syncStatus == SyncStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  'فشل المزامنة: ${state.syncError ?? "خطأ غير معروف"}',
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.only(
                  bottom: 40.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
            );
        }
      },
      // 2. بناء الواجهة بناءً على كل تغيرات الحالة (التحميل والمزامنة)
      builder: (context, dashboardState) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              'لوحة التحكم',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.steel_blue,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: _buildBody(context, dashboardState),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DashboardState dashboardState) {
    // حالة التحميل الأولية (عندما لا تكون هناك بيانات قديمة لعرضها)
    if (dashboardState.status == DashboardStatus.loading &&
        dashboardState.dashboardData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // حالة الفشل (إذا لم تكن هناك بيانات قديمة لعرضها)
    if (dashboardState.status == DashboardStatus.failure &&
        dashboardState.dashboardData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dashboardState.error ?? 'حدث خطأ غير متوقع'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // محاولة إعادة التحميل يدوياً
                final halaqaId =
                    context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
                if (halaqaId != null) {
                  context.read<DashboardBloc>().add(
                    LoadDashboardData(halaqaId: halaqaId),
                  );
                }
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    // في كل الحالات الأخرى (نجاح، أو فشل مع وجود بيانات قديمة)، نعرض البيانات
    return RefreshIndicator(
      onRefresh: () async {
        final halaqaId = context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
        if (halaqaId != null) {
          context.read<DashboardBloc>().add(
            LoadDashboardData(halaqaId: halaqaId),
          );
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // عرض رسالة تحذير إذا فشل آخر تحديث ولكن لدينا بيانات قديمة
          if (dashboardState.status == DashboardStatus.failure)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.orange.withOpacity(0.2),
              child: Text(
                'فشل آخر تحديث. البيانات المعروضة قد تكون قديمة.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange.shade800),
              ),
            ),

          // تمرير حالة المزامنة إلى الويدجت
          _buildSyncCard(context, dashboardState.syncStatus),
          const SizedBox(height: 16),
          _buildSummaryCard(dashboardState.dashboardData?.summary),
          const SizedBox(height: 16),
          _buildSectionTitle('بحاجة لمتابعة ⚠️'),
          _buildNeedsAttentionCard(
            dashboardState.dashboardData?.needsAttention,
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('أفضل الطلاب هذا الأسبوع 🏆'),
          _buildTopStudentsCard(dashboardState.dashboardData?.topStudents),
          const SizedBox(height: 16),
          _buildSectionTitle('إحصائيات الحضور (آخر 30 يوم)'),
          _buildAttendanceChartCard(
            dashboardState.dashboardData?.attendanceChart,
          ),
        ],
      ),
    );
  }

  Widget _buildSyncCard(BuildContext context, SyncStatus syncStatus) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.dark_teal_blue.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppColors.dark_teal_blue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.cloud_sync_rounded, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              'مزامنة البيانات مع السيرفر',
              style: GoogleFonts.tajawal(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'اضغط هنا لترحيل كل البيانات المحفوظة محلياً إلى السيرفر.',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            // بناء الزر أو مؤشر التحميل بناءً على الحالة
            if (syncStatus == SyncStatus.syncing)
              const CircularProgressIndicator(color: Colors.white)
            else
              ElevatedButton.icon(
                onPressed: () {
                  final halaqaId =
                      context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
                  if (halaqaId != null) {
                    context.read<DashboardBloc>().add(
                      SyncAllDataRequested(halaqaId),
                    );
                  } else {
                    // رسالة للمستخدم في حال لم يتم تحميل الحلقة بعد
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'لا يمكن المزامنة قبل تحميل بيانات الحلقة.',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 40.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.upload_rounded),
                label: Text('بدء الترحيل', style: GoogleFonts.tajawal()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.golden_orange,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
  // دالة منفصلة لبناء محتوى الشاشة لتنظيم الكود
  // Widget _buildBody(BuildContext context, DashboardState dashboardState) {
  //   if (dashboardState.status == DashboardStatus.loading &&
  //       dashboardState.dashboardData == null) {
  //     return const Center(child: CircularProgressIndicator());
  //   }

  //   if (dashboardState.status == DashboardStatus.failure) {
  //     return Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(dashboardState.error ?? 'حدث خطأ غير متوقع'),
  //           const SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: () {
  //               final halaqaId =
  //                   context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
  //               if (halaqaId != null) {
  //                 context.read<DashboardBloc>().add(
  //                   LoadDashboardData(halaqaId: halaqaId),
  //                 );
  //               }
  //             },
  //             child: const Text('إعادة المحاولة'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  //   return RefreshIndicator(
  //     onRefresh: () async {
  //       final halaqaId = context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
  //       log("🔁 [UI] تم سحب التحديث - halaqaId = $halaqaId");
  //       if (halaqaId != null) {
  //         context.read<DashboardBloc>().add(
  //           LoadDashboardData(halaqaId: halaqaId),
  //         );
  //       }
  //     },
  //     child: ListView(
  //       padding: const EdgeInsets.all(16.0),
  //       children: [
  //         _buildSyncCard(context), // هذا الكود لم يتغير
  //         const SizedBox(height: 16),
  //         _buildSummaryCard(dashboardState.dashboardData?.summary),
  //         const SizedBox(height: 16),
  //         _buildSectionTitle('بحاجة لمتابعة ⚠️'),
  //         _buildNeedsAttentionCard(
  //           dashboardState.dashboardData?.needsAttention,
  //         ),
  //         const SizedBox(height: 16),
  //         _buildSectionTitle('أفضل الطلاب هذا الأسبوع 🏆'),
  //         _buildTopStudentsCard(dashboardState.dashboardData?.topStudents),
  //         const SizedBox(height: 16),
  //         _buildSectionTitle('إحصائيات الحضور (آخر 30 يوم)'),
  //         _buildAttendanceChartCard(
  //           dashboardState.dashboardData?.attendanceChart,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.tajawal(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.night_blue,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(DashboardSummary? summary) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              'الحضور اليوم',
              summary?.presentToday.toString() ?? '...',
              Icons.check_circle,
              AppColors.teal_blue,
            ),
            _buildSummaryItem(
              'الغياب اليوم',
              summary?.absentToday.toString() ?? '...',
              Icons.cancel,
              Colors.red.shade600,
            ),
            _buildSummaryItem(
              'تم تقييمهم',
              summary?.evaluatedToday.toString() ?? '...',
              Icons.fact_check,
              AppColors.golden_orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.tajawal(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.night_blue,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.tajawal(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildNeedsAttentionCard(List<NeedsAttentionStudent>? students) {
    if (students == null || students.isEmpty) {
      return const Card(
        child: ListTile(title: Text('لا يوجد طلاب بحاجة لمتابعة خاصة حالياً.')),
      );
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children:
              students
                  .map(
                    (student) => ListTile(
                      leading: const Icon(
                        Icons.person_pin,
                        color: Colors.orange,
                      ),
                      title: Text(student.name, style: GoogleFonts.tajawal()),
                      subtitle: Text(
                        'التقدير السابق: ${student.lastEvaluation}',
                        style: GoogleFonts.tajawal(),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildTopStudentsCard(List<TopStudent>? students) {
    if (students == null || students.isEmpty) {
      return const Card(
        child: ListTile(title: Text('لا توجد بيانات كافية لعرض أفضل الطلاب.')),
      );
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(students.length, (index) {
            return _buildTopStudentItem(students[index].name, index + 1);
          }),
        ),
      ),
    );
  }

  Widget _buildTopStudentItem(String name, int rank) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.light_sky_blue,
          child: Text(
            rank.toString(),
            style: const TextStyle(
              fontSize: 24,
              color: AppColors.steel_blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAttendanceChartCard(AttendanceChartData? data) {
    final double present = data?.present.toDouble() ?? 0;
    final double absent = data?.absent.toDouble() ?? 0;
    final bool hasData = present > 0 || absent > 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child:
              hasData
                  ? PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: AppColors.teal_blue,
                          value: present,
                          title:
                              '${((present / (present + absent)) * 100).toStringAsFixed(0)}%',
                          radius: 80,
                          titleStyle: GoogleFonts.tajawal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.red.shade400,
                          value: absent,
                          title:
                              '${((absent / (present + absent)) * 100).toStringAsFixed(0)}%',
                          radius: 80,
                          titleStyle: GoogleFonts.tajawal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  )
                  : const Center(
                    child: Text(
                      'لا توجد بيانات حضور كافية لعرض الرسم البياني.',
                    ),
                  ),
        ),
      ),
    );
  }

  // Widget _buildSyncCard(BuildContext context) {
  //   return Card(
  //     elevation: 4,
  //     shadowColor: AppColors.dark_teal_blue.withOpacity(0.5),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     color: AppColors.dark_teal_blue,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           const Icon(Icons.cloud_sync_rounded, color: Colors.white, size: 40),
  //           const SizedBox(height: 8),
  //           Text(
  //             'مزامنة البيانات مع السيرفر',
  //             style: GoogleFonts.tajawal(
  //               color: Colors.white,
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             'اضغط هنا لترحيل كل البيانات المحفوظة محلياً إلى السيرفر.',
  //             textAlign: TextAlign.center,
  //             style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 14),
  //           ),
  //           const SizedBox(height: 16),
  //           BlocBuilder<DashboardBloc, DashboardState>(
  //             buildWhen:
  //                 (previous, current) =>
  //                     previous.syncStatus != current.syncStatus,
  //             builder: (context, dashboardState) {
  //               if (dashboardState.syncStatus == SyncStatus.syncing) {
  //                 return const CircularProgressIndicator(color: Colors.white);
  //               }
  //               return ElevatedButton.icon(
  //                 onPressed: () {
  //                   final halaqaId =
  //                       context.read<HalaqaBloc>().state.halaqa?.idhalaqa;

  //                   print("☁️ [UI] بدأ ترحيل البيانات - halaqaId = $halaqaId");
  //                   if (halaqaId != null) {
  //                     // ✅ أرسل الحدث SyncAllDataRequested فقط
  //                     context.read<DashboardBloc>().add(
  //                       SyncAllDataRequested(halaqaId),
  //                     );
  //                     // ❌ حذف Future.delayed
  //                   }
  //                 },
  //                 icon: const Icon(Icons.upload_rounded),
  //                 label: Text('بدء الترحيل', style: GoogleFonts.tajawal()),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColors.golden_orange,
  //                   foregroundColor: Colors.white,
  //                 ),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
