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

  // In lib/features/center_manager/bloc/reports_bloc/reports_bloc.dart

  // ... (constructor and other methods)

  // 1. معالج تقرير الطلاب
  Future<void> _onGenerateStudentsListReport(
    GenerateStudentsListReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReportGenerationStatus.loading,
        message: 'جاري جلب بيانات الطلاب...',
      ),
    );
    final result = await _repository.getStudentsReportData();
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ReportGenerationStatus.failure,
          message: failure.message,
        ),
      ),
      (data) async {
        if (data.isEmpty) {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.failure,
              message: 'لا يوجد طلاب لعرضهم في التقرير.',
            ),
          );
          return;
        }
        try {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.loading,
              message: 'جاري إنشاء ملف Excel...',
            ),
          );

          // ✅ --- استخدم العناوين والمفاتيح العربية الصحيحة --- ✅
          await _excelExporter.exportAndShare(
            data: data,
            fileName: 'تقرير_بيانات_الطلاب',
            sheetName: 'الطلاب',
            headers: [
              'اسم الطالب',
              'اسم الأب',
              'رقم الهاتف',
              'الحلقة',
              'المرحلة',
              'متوسط تقييم الحفظ',
              'متوسط تقييم المراجعة',
              'تاريخ التسجيل',
            ],
            keys: [
              'اسم_الطالب',
              'اسم_الأب',
              'رقم_الهاتف',
              'الحلقة',
              'المرحلة',
              'متوسط_تقييم_الحفظ',
              'متوسط_تقييم_المراجعة',
              'تاريخ_التسجيل',
            ],
          );

          emit(
            state.copyWith(
              status: ReportGenerationStatus.success,
              message: 'تم تصدير تقرير الطلاب بنجاح!',
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.failure,
              message: 'فشل إنشاء الملف: ${e.toString()}',
            ),
          );
        }
      },
    );
  }

  // 2. معالج تقرير الأساتذة
  Future<void> _onGenerateTeachersListReport(
    GenerateTeachersListReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReportGenerationStatus.loading,
        message: 'جاري جلب بيانات الأساتذة...',
      ),
    );
    final result = await _repository.getTeachersReportData();
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ReportGenerationStatus.failure,
          message: failure.message,
        ),
      ),
      (data) async {
        if (data.isEmpty) {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.failure,
              message: 'لا توجد بيانات أساتذة لعرضها.',
            ),
          );
          return;
        }
        try {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.loading,
              message: 'جاري إنشاء ملف Excel...',
            ),
          );

          // ✅ --- استخدم العناوين والمفاتيح العربية الصحيحة --- ✅
          await _excelExporter.exportAndShare(
            data: data,
            fileName: 'تقرير_بيانات_الأساتذة',
            sheetName: 'الأساتذة',
            headers: [
              'اسم الأستاذ',
              'رقم الهاتف',
              'المستوى التعليمي',
              'عدد الحلقات المسندة',
              'تاريخ بدء العمل',
              'حالة الحساب',
            ],
            keys: [
              'اسم_الأستاذ',
              'رقم_الهاتف',
              'المستوى_التعليمي',
              'عدد_الحلقات_المسندة',
              'تاريخ_بدء_العمل',
              'حالة_الحساب',
            ],
          );

          emit(
            state.copyWith(
              status: ReportGenerationStatus.success,
              message: 'تم تصدير تقرير الأساتذة بنجاح!',
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.failure,
              message: 'فشل إنشاء الملف: ${e.toString()}',
            ),
          );
        }
      },
    );
  }

  // 3. معالج تقرير الحضور
  Future<void> _onGenerateAttendanceReport(
    GenerateAttendanceReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReportGenerationStatus.loading,
        message: 'جاري جلب بيانات الحضور...',
      ),
    );
    final result = await _repository.getAttendanceReportData(
      startDate: event.startDate,
      endDate: event.endDate,
      halaqaId: event.halaqaId,
    );
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ReportGenerationStatus.failure,
          message: failure.message,
        ),
      ),
      (data) async {
        if (data.isEmpty) {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.failure,
              message: 'لا توجد بيانات حضور في الفترة المحددة.',
            ),
          );
          return;
        }
        try {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.loading,
              message: 'جاري إنشاء ملف Excel...',
            ),
          );

          // ✅ --- استخدم العناوين والمفاتيح العربية الصحيحة --- ✅
          await _excelExporter.exportAndShare(
            data: data,
            fileName: 'تقرير_الحضور_والغياب',
            sheetName: 'الحضور',
            headers: [
              'اسم الطالب',
              'الحلقة',
              'التاريخ',
              'الحالة',
              'تقييم الحفظ',
              'تقييم المراجعة',
            ],
            keys: [
              'اسم_الطالب',
              'الحلقة',
              'التاريخ',
              'الحالة',
              'تقييم_الحفظ',
              'تقييم_المراجعة',
            ],
          );

          emit(
            state.copyWith(
              status: ReportGenerationStatus.success,
              message: 'تم تصدير تقرير الحضور بنجاح!',
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: ReportGenerationStatus.failure,
              message: 'فشل إنشاء الملف: ${e.toString()}',
            ),
          );
        }
      },
    );
  }
}
