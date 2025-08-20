import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ✅ تأكد من استيراد الخدمة الصحيحة
import 'package:flutter_admain_center/core/services/excel_exporter_service.dart'; 
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final CenterManagerRepository _repository;
  final ExcelExporterService _excelExporter;

  ReportsBloc({required CenterManagerRepository centerManagerRepository})
      : _repository = centerManagerRepository,
        _excelExporter = ExcelExporterService(),
        super(const ReportsState()) {
    on<GenerateStudentsListReport>(_onGenerateStudentsListReport);
    on<GenerateTeachersListReport>(_onGenerateTeachersListReport);
    on<GenerateAttendanceReport>(_onGenerateAttendanceReport);
  }

  // معالج تقرير الطلاب
  Future<void> _onGenerateStudentsListReport(
    GenerateStudentsListReport event, Emitter<ReportsState> emit
  ) async {
    emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري جلب بيانات الطلاب...'));
    final result = await _repository.getStudentsReportData();
    await result.fold(
      (failure) async => emit(state.copyWith(status: ReportGenerationStatus.failure, message: failure.message)),
      (data) async {
        if (data.isEmpty) {
          emit(state.copyWith(status: ReportGenerationStatus.failure, message: 'لا يوجد طلاب لعرضهم في التقرير.'));
          return;
        }
        try {
          emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري إنشاء ملف Excel...'));
          
          // ==================== هنا هو التعديل المطلوب ====================
          // تمرير العناوين والمفاتيح الصحيحة بناءً على الـ API
          await _excelExporter.exportAndShare(
            data: data,
            fileName: 'تقرير_بيانات_الطلاب',
            sheetName: 'الطلاب',
            // العناوين التي ستظهر في ملف Excel
            headers: ['الاسم الكامل', 'اسم الأب', 'رقم الهاتف', 'الحلقة', 'المرحلة', 'تاريخ الميلاد', 'الحالة'],
            // المفاتيح التي يجب البحث عنها في البيانات القادمة من الـ API
            keys:    ['الاسم الكامل', 'اسم الأب', 'رقم الهاتف', 'الحلقة', 'المرحلة', 'تاريخ الميلاد', 'الحالة'],
          );
          // ===============================================================

          emit(state.copyWith(status: ReportGenerationStatus.success, message: 'تم تصدير التقرير بنجاح!'));
        } catch (e) {
          emit(state.copyWith(status: ReportGenerationStatus.failure, message: 'فشل إنشاء الملف: ${e.toString()}'));
        }
      },
    );
  }

  // معالج تقرير الأساتذة
  Future<void> _onGenerateTeachersListReport(
    GenerateTeachersListReport event, Emitter<ReportsState> emit
  ) async {
    emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري جلب بيانات الأساتذة...'));
    final result = await _repository.getTeachersReportData();
    await result.fold(
      (failure) async => emit(state.copyWith(status: ReportGenerationStatus.failure, message: failure.message)),
      (data) async {
        if (data.isEmpty) {
          emit(state.copyWith(status: ReportGenerationStatus.failure, message: 'لا توجد بيانات لعرضها في التقرير.'));
          return;
        }
        try {
          emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري إنشاء ملف Excel...'));

          // ==================== هنا هو التعديل المطلوب ====================
          await _excelExporter.exportAndShare(
            data: data,
            fileName: 'تقرير_بيانات_الأساتذة',
            sheetName: 'الأساتذة',
            headers: ['الاسم الكامل', 'رقم الهاتف', 'البريد الإلكتروني', 'المستوى التعليمي', 'الأجزاء المحفوظة', 'تاريخ بدء العمل', 'الحالة'],
            keys:    ['الاسم الكامل', 'رقم الهاتف', 'البريد الإلكتروني', 'المستوى التعليمي', 'الأجزاء المحفوظة', 'تاريخ بدء العمل', 'الحالة'],
          );
          // ===============================================================

          emit(state.copyWith(status: ReportGenerationStatus.success, message: 'تم تصدير التقرير بنجاح!'));
        } catch (e) {
          emit(state.copyWith(status: ReportGenerationStatus.failure, message: 'فشل إنشاء الملف: ${e.toString()}'));
        }
      },
    );
  }

  // معالج تقرير الحضور
  Future<void> _onGenerateAttendanceReport(
    GenerateAttendanceReport event, Emitter<ReportsState> emit
  ) async {
    emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري جلب بيانات الحضور...'));
    final result = await _repository.getAttendanceReportData(
      startDate: event.startDate,
      endDate: event.endDate,
      halaqaId: event.halaqaId,
    );
    await result.fold(
      (failure) async => emit(state.copyWith(status: ReportGenerationStatus.failure, message: failure.message)),
      (data) async {
        if (data.isEmpty) {
          emit(state.copyWith(status: ReportGenerationStatus.failure, message: 'لا توجد بيانات حضور في الفترة المحددة.'));
          return;
        }
        try {
          emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري إنشاء ملف Excel...'));
          
          // ==================== هنا هو التعديل المطلوب ====================
          await _excelExporter.exportAndShare(
            data: data,
            fileName: 'تقرير_الحضور_والغياب',
            sheetName: 'الحضور',
            // افترضت أن API الحضور يرجع مفاتيح انجليزية، إذا كانت عربية قم بتغييرها
            headers: ['الاسم الأول', 'الكنية', 'اسم الحلقة', 'التاريخ', 'الحالة'],
            keys:    ['first_name', 'last_name', 'halaqa_name', 'date', 'status'],
          );
          // ===============================================================

          emit(state.copyWith(status: ReportGenerationStatus.success, message: 'تم تصدير التقرير بنجاح!'));
        } catch (e) {
          emit(state.copyWith(status: ReportGenerationStatus.failure, message: 'فشل إنشاء الملف: ${e.toString()}'));
        }
      },
    );
  }
}
