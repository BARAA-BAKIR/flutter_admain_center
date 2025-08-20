// In features/super_admin/view/aggregated_reports_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/services/report_exporter.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/reports_bloc/reports_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/widgets/report_data_table.dart';
import 'package:flutter_admain_center/features/super_admin/widgets/report_filter_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AggregatedReportsScreen extends StatelessWidget {
  const AggregatedReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We provide the BLoC here, at the top of the screen's widget tree.
    return BlocProvider(
      create:
          (context) => ReportsBloc(
            superAdminRepository: context.read<SuperAdminRepository>(),
          )..add(LoadReportFilters()), // Load centers list for the filter
      child: const AggregatedReportsView(),
    );
  }
}

class AggregatedReportsView extends StatelessWidget {
  const AggregatedReportsView({super.key});

  // A helper function to show the filter dialog
  void _showFilterDialog(BuildContext context, String reportType) {
    showDialog(
      context: context,
      builder: (_) {
        // We need to provide the existing BLoC to the dialog
        return BlocProvider.value(
          value: BlocProvider.of<ReportsBloc>(context),
          child: ReportFilterDialog(
            reportType: reportType,
            onApply: (filters) {
              // Dispatch the correct event based on the report type
              if (reportType == 'students') {
                context.read<ReportsBloc>().add(
                  GenerateStudentReport(
                    startDate: filters['startDate'],
                    endDate: filters['endDate'],
                  ),
                );
              } else if (reportType == 'attendance') {
                context.read<ReportsBloc>().add(
                  GenerateAttendanceReport(
                    startDate: filters['startDate']!, // Required for attendance
                    endDate: filters['endDate']!, // Required for attendance
                    centerId: filters['centerId'],
                  ),
                );
              } else if (reportType == 'teachers') {
                context.read<ReportsBloc>().add(GenerateTeacherReport());
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              'التقارير المجمعة',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
            centerTitle: true,
          ),
          floatingActionButton:
              (state.status == ReportStatus.success &&
                      state.reportData.isNotEmpty)
                  ? FloatingActionButton.extended(
                    onPressed: () {
                      // Call the export function with the current data
                      exportToExcel(
                        context,
                        data: state.reportData,
                        reportName:
                            'SuperAdmin_Report', // You can make this dynamic
                      );
                    },
                    label: const Text('تصدير إلى Excel'),
                    icon: const Icon(Icons.download_for_offline_outlined),
                    backgroundColor: Colors.green.shade700,
                  )
                  : null,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إنشاء تقرير شامل',
                  style: GoogleFonts.tajawal(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.night_blue,
                  ),
                ),
                Text(
                  'اختر نوع التقرير، قم بتطبيق الفلاتر، ثم قم بتصدير النتائج.',
                  style: GoogleFonts.tajawal(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                // Report selection buttons
                SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildReportTypeChip(
                        context,
                        'بيانات الطلاب',
                        Icons.people_alt_outlined,
                        'students',
                      ),
                      _buildReportTypeChip(
                        context,
                        'سجل الحضور',
                        Icons.event_note_outlined,
                        'attendance',
                      ),
                      _buildReportTypeChip(
                        context,
                        'بيانات الأساتذة',
                        Icons.school_outlined,
                        'teachers',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                // The area to display the results
                Expanded(
                  child: BlocBuilder<ReportsBloc, ReportsState>(
                    builder: (context, state) {
                      if (state.status == ReportStatus.loading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                state.loadingMessage ?? 'جاري التحميل...',
                                style: GoogleFonts.tajawal(),
                              ),
                            ],
                          ),
                        );
                      }
                      if (state.status == ReportStatus.failure) {
                        return Center(
                          child: Text(
                            'حدث خطأ: ${state.errorMessage}',
                            style: GoogleFonts.tajawal(color: Colors.red),
                          ),
                        );
                      }
                      if (state.status == ReportStatus.success &&
                          state.reportData.isNotEmpty) {
                        // Display the data table with the results
                        return ReportDataTable(data: state.reportData);
                      }
                      // Initial state or success with no data
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.summarize_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لم يتم إنشاء أي تقرير بعد',
                              style: GoogleFonts.tajawal(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'اختر أحد الأنواع في الأعلى لبدء إنشاء تقريرك',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportTypeChip(
    BuildContext context,
    String label,
    IconData icon,
    String reportType,
  ) {
    return ActionChip(
      avatar: Icon(icon, color: AppColors.steel_blue),
      label: Text(
        label,
        style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
      ),
      onPressed: () => _showFilterDialog(context, reportType),
      backgroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
