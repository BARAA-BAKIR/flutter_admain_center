import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/report_option_card.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/filter_data_bloc/filter_data_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/reports_bloc/reports_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/widgets/report_filter_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ReportsBloc(
            centerManagerRepository: context.read<CenterManagerRepository>(),
          ),
      child: BlocListener<ReportsBloc, ReportsState>(
        listener: (context, state) {
          final message = state.message;
          // عرض الرسائل فقط عند انتهاء العملية (نجاح أو فشل)
          if (message != null &&
              state.status != ReportGenerationStatus.loading) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor:
                      state.status == ReportGenerationStatus.failure
                          ? Colors.redAccent
                          : Colors.green,
                ),
              );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              'التقارير',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
          ),
          body: BlocBuilder<ReportsBloc, ReportsState>(
            builder: (context, state) {
              // عرض شاشة التحميل إذا كانت أي عملية جارية
              if (state.status == ReportGenerationStatus.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        state.message ?? 'جاري العمل...',
                        style: GoogleFonts.tajawal(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              // عرض قائمة التقارير في الحالات الأخرى
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Text(
                      'اختر نوع التقرير المطلوب',
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.night_blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'يمكنك تخصيص كل تقرير وتصديره كملف Excel.',
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- بطاقات التقارير ---
                    ReportOptionCard(
                      title: 'تقرير بيانات الطلاب',
                      description:
                          'قائمة كاملة ببيانات الطلاب وحلقاتهم ومراحلهم.',
                      icon: Icons.description_rounded,
                      onTap: () {
                        context.read<ReportsBloc>().add(
                          GenerateStudentsListReport(),
                        );
                      },
                    ),
                    ReportOptionCard(
                      title: 'تقرير بيانات الأساتذة',
                      description:
                          'قائمة كاملة ببيانات الأساتذة ومعلوماتهم الوظيفية.',
                      icon: Icons.assessment_rounded,
                      onTap: () {
                        context.read<ReportsBloc>().add(
                          GenerateTeachersListReport(),
                        );
                      },
                    ),
                    ReportOptionCard(
                      title: 'تقرير الحضور والغياب',
                      description: 'سجل الحضور والغياب للطلاب خلال فترة محددة.',
                      icon: Icons.event_available_rounded,
                      onTap: () {
                        // نقرأ الـ repository مرة واحدة هنا
                        final repository =
                            context.read<CenterManagerRepository>();
                        // نقرأ ReportsBloc الحالي لنرسل له الحدث لاحقاً
                        final reportsBloc = context.read<ReportsBloc>();

                        showDialog(
                          context: context,
                          // نستخدم BlocProvider لتوفير FilterDataBloc لمربع الحوار فقط
                          builder:
                              (_) => BlocProvider(
                                create:
                                    (context) =>
                                        FilterDataBloc(repository: repository)
                                          ..add(
                                            LoadFilterData(),
                                          ), // نرسل حدث جلب البيانات فوراً
                                child: ReportFilterDialog(
                                  needsDateRange: true,
                                  needsHalaqa: true,
                                  onApply: (startDate, endDate, halaqaId) {
                                    if (startDate != null && endDate != null) {
                                      // نستخدم reportsBloc الذي قرأناه لإرسال الحدث
                                      reportsBloc.add(
                                        GenerateAttendanceReport(
                                          startDate: startDate,
                                          endDate: endDate,
                                          halaqaId: halaqaId,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'الرجاء تحديد نطاق التاريخ أولاً',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                        );
                      },
                    ),
                    // يمكنك إضافة المزيد من التقارير هنا بنفس الطريقة
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
