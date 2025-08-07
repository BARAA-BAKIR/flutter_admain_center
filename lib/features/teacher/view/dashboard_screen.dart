
import 'package:flutter/material.dart';
//import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
import 'package:flutter_admain_center/features/teacher/bloc/dashboard/dashboard_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     print("🔵 [UI] تم بناء شاشة DashboardScreen");

//     return BlocListener<HalaqaBloc, HalaqaState>(
//       listener: (context, halaqaState) {
//         print("📩 [UI] BlocListener تم استدعاؤه");
//         print("📌 [UI] قيمة halaqaId: ${halaqaState.halaqa?.idhalaqa}");

//         if (halaqaState.halaqa != null) {
//           print("✅ [UI] سيتم استدعاء LoadDashboardData()");
//           context.read<DashboardBloc>().add(
//             LoadDashboardData(halaqaId: halaqaState.halaqa!.idhalaqa),
//           );
//         } else {
//           print("⚠️ [UI] halaqaId غير متوفر، لن يتم الطلب");
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar: AppBar(
//           title: Text(
//             'لوحة التحكم',
//             style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: AppColors.steel_blue,
//           foregroundColor: Colors.white,
//           centerTitle: true,
//         ),

        
//         body: BlocBuilder<DashboardBloc, DashboardState>(
//           builder: (context, dashboardState) {
//             print("🔄 [UI] DashboardState.status = ${dashboardState.status}");

//             if (dashboardState.status == DashboardStatus.loading &&
//                 dashboardState.dashboardData == null) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (dashboardState.status == DashboardStatus.failure) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(dashboardState.error ?? 'حدث خطأ غير متوقع'),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: () {
//                         final halaqaId =
//                             context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
//                         print(
//                           "🔁 [UI] زر إعادة المحاولة ضغط - halaqaId = $halaqaId",
//                         );
//                         if (halaqaId != null) {
//                           context.read<DashboardBloc>().add(
//                             LoadDashboardData(halaqaId: halaqaId),
//                           );
//                         }
//                       },
//                       child: const Text('إعادة المحاولة'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return RefreshIndicator(
//               onRefresh: () async {
//                 var halaqaId =
//                     context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
//                 print("🔁 [UI] تم سحب التحديث - halaqaId = $halaqaId");
//                 if (halaqaId == null) {
//                   final local = TeacherLocalDatasource();
//                   final cached = await local.getCachedHalaqaData();
//                   halaqaId = cached?.idhalaqa;
//                   debugPrint("♻️ جلبنا HalaqaId من الكاش = $halaqaId");
//                 }
//                 if (halaqaId != null) {
//                   context.read<DashboardBloc>().add(
//                     LoadDashboardData(halaqaId: halaqaId),
//                   );
//                 }
//               },
//               child: ListView(
//                 padding: const EdgeInsets.all(16.0),
//                 children: [
//                   _buildSyncCard(context),
//                   const SizedBox(height: 16),
//                   _buildSummaryCard(dashboardState.dashboardData?.summary),
//                   const SizedBox(height: 16),
//                   _buildSectionTitle('بحاجة لمتابعة ⚠️'),
//                   _buildNeedsAttentionCard(
//                     dashboardState.dashboardData?.needsAttention,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildSectionTitle('أفضل الطلاب هذا الأسبوع 🏆'),
//                   _buildTopStudentsCard(
//                     dashboardState.dashboardData?.topStudents,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildSectionTitle('إحصائيات الحضور (آخر 30 يوم)'),
//                   _buildAttendanceChartCard(
//                     dashboardState.dashboardData?.attendanceChart,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // ====================  هنا هو التعديل الكامل ====================
    return BlocConsumer<DashboardBloc, DashboardState>(
      // 1. الاستماع فقط لتغيرات حالة المزامنة
      listenWhen: (previous, current) => previous.syncStatus != current.syncStatus,
      listener: (context, state) {
        // لا تعرض أي شيء أثناء التحميل
        if (state.syncStatus == SyncStatus.syncing) return;

        // عند النجاح
        if (state.syncStatus == SyncStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('تمت مزامنة البيانات بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
        }
        // عند الفشل
        else if (state.syncStatus == SyncStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('فشل المزامنة: ${state.syncError ?? "خطأ غير معروف"}'),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      // 2. بناء الواجهة بناءً على حالة تحميل البيانات الرئيسية
      builder: (context, dashboardState) {
        // هذا الجزء هو الـ body الأصلي للشاشة
        return BlocListener<HalaqaBloc, HalaqaState>(
          listener: (context, halaqaState) {
            if (halaqaState.halaqa != null) {
              context.read<DashboardBloc>().add(
                    LoadDashboardData(halaqaId: halaqaState.halaqa!.idhalaqa),
                  );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              title: Text('لوحة التحكم', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              backgroundColor: AppColors.steel_blue,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            body: _buildBody(context, dashboardState), // استخراج الـ body في دالة منفصلة
          ),
        );
      },
    );
  }

  // دالة منفصلة لبناء محتوى الشاشة لتنظيم الكود
  Widget _buildBody(BuildContext context, DashboardState dashboardState) {
    if (dashboardState.status == DashboardStatus.loading && dashboardState.dashboardData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dashboardState.status == DashboardStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dashboardState.error ?? 'حدث خطأ غير متوقع'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final halaqaId = context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
                if (halaqaId != null) {
                  context.read<DashboardBloc>().add(LoadDashboardData(halaqaId: halaqaId));
                }
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final halaqaId = context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
        if (halaqaId != null) {
          context.read<DashboardBloc>().add(LoadDashboardData(halaqaId: halaqaId));
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSyncCard(context), // هذا الكود لم يتغير
          const SizedBox(height: 16),
          _buildSummaryCard(dashboardState.dashboardData?.summary),
          const SizedBox(height: 16),
          _buildSectionTitle('بحاجة لمتابعة ⚠️'),
          _buildNeedsAttentionCard(dashboardState.dashboardData?.needsAttention),
          const SizedBox(height: 16),
          _buildSectionTitle('أفضل الطلاب هذا الأسبوع 🏆'),
          _buildTopStudentsCard(dashboardState.dashboardData?.topStudents),
          const SizedBox(height: 16),
          _buildSectionTitle('إحصائيات الحضور (آخر 30 يوم)'),
          _buildAttendanceChartCard(dashboardState.dashboardData?.attendanceChart),
        ],
      ),
    );
  }
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

  Widget _buildSyncCard(BuildContext context) {
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
            BlocBuilder<DashboardBloc, DashboardState>(
              buildWhen:
                  (previous, current) =>
                      previous.syncStatus != current.syncStatus,
              builder: (context, dashboardState) {
                if (dashboardState.syncStatus == SyncStatus.syncing) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                return ElevatedButton.icon(
                  onPressed: () {
                    final halaqaId =
                        context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
                    print("☁️ [UI] بدأ ترحيل البيانات - halaqaId = $halaqaId");
                    context.read<DashboardBloc>().add(SyncAllDataRequested());
                    if (halaqaId != null) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        context.read<DashboardBloc>().add(
                          LoadDashboardData(halaqaId: halaqaId),
                        );
                      });
                    }
                  },
                  icon: const Icon(Icons.upload_rounded),
                  label: Text('بدء الترحيل', style: GoogleFonts.tajawal()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.golden_orange,
                    foregroundColor: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
