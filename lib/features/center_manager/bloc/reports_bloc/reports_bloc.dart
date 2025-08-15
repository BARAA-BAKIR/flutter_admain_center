import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final CenterManagerRepository centerManagerRepository;

  ReportsBloc({required this.centerManagerRepository}) : super(const ReportsState()) {
    on<GenerateStudentsReport>(_onGenerateStudentsReport);
    on<GenerateAttendanceReport>(_onGenerateAttendanceReport);
  }

  Future<void> _onGenerateStudentsReport(GenerateStudentsReport event, Emitter<ReportsState> emit) async {
    emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري جلب البيانات...'));
    
    final result = await centerManagerRepository.getAllStudentsForReport();

    await result.fold(
      (failure) async => emit(state.copyWith(status: ReportGenerationStatus.failure, message: failure.message)),
      (studentsData) async {
        emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري إنشاء ملف Excel...'));
        try {
          // 1. إنشاء ملف Excel
          var excel = Excel.createExcel();
          Sheet sheet = excel['بيانات الطلاب'];

          // 2. إضافة العناوين
          final headers = ['ID', 'الاسم الكامل', 'الحلقة', 'البريد الإلكتروني', 'رقم الهاتف', 'تاريخ الميلاد'];
          sheet.appendRow(headers.map((header) => TextCellValue(header)).toList());

          // 3. إضافة بيانات الطلاب
          for (final student in studentsData) {
            sheet.appendRow([
              TextCellValue(student['id'].toString()),
              TextCellValue(student['full_name'].toString()),
              TextCellValue(student['halaqa_name'].toString()),
              TextCellValue(student['email'].toString()),
              TextCellValue(student['phone_number'].toString()),
              TextCellValue(student['birth_date'].toString()),
            ]);
          }

          // 4. حفظ ومشاركة الملف
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/students_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
          final fileBytes = excel.save();

          if (fileBytes != null) {
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(fileBytes);
            await OpenFilex.open(filePath);
            // await Share.shareXFiles([XFile(filePath)], text: 'تقرير بيانات الطلاب');
            emit(state.copyWith(status: ReportGenerationStatus.success, message: 'تم إنشاء ومشاركة التقرير بنجاح.'));
          } else {
            throw Exception('فشل حفظ ملف Excel.');
          }
        } catch (e) {
          emit(state.copyWith(status: ReportGenerationStatus.failure, message: 'حدث خطأ أثناء إنشاء الملف: ${e.toString()}'));
        }
      },
    );
  }

   Future<void> _onGenerateAttendanceReport(GenerateAttendanceReport event, Emitter<ReportsState> emit) async {
    emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري جلب بيانات الحضور...'));

    final result = await centerManagerRepository.getAttendanceReportData(
      startDate: event.startDate,
      endDate: event.endDate,
      halaqaId: event.halaqaId,
    );

    await result.fold(
      (failure) async => emit(state.copyWith(status: ReportGenerationStatus.failure, message: failure.message)),
      (reportData) async {
        if (reportData.isEmpty) {
          emit(state.copyWith(status: ReportGenerationStatus.success, message: 'لا توجد سجلات حضور في الفترة المحددة.'));
          return;
        }

        emit(state.copyWith(status: ReportGenerationStatus.loading, message: 'جاري إنشاء ملف Excel...'));
        try {
          var excel = Excel.createExcel();
          Sheet sheet = excel['تقرير الحضور'];

          // إضافة العناوين
          final headers = ['اسم الطالب', 'اسم الحلقة', 'التاريخ', 'الحالة'];
          sheet.appendRow(headers.map((header) => TextCellValue(header)).toList());

          // إضافة بيانات الحضور
          for (final record in reportData) {
            sheet.appendRow([
              TextCellValue((record['first_name'] ?? '') + ' ' + (record['last_name'] ?? '')),
              TextCellValue(record['halaqa_name']?.toString() ?? 'N/A'),
              TextCellValue(record['date']?.toString() ?? 'N/A'),
              TextCellValue(record['status'] == 'present' ? 'حاضر' : 'غائب'),
            ]);
          }

          // حفظ ومشاركة الملف
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/attendance_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
          final fileBytes = excel.save();

          if (fileBytes != null) {
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(fileBytes);
 await OpenFilex.open(filePath);
            // await Share.shareXFiles([XFile(filePath)], text: 'تقرير الحضور والغياب');
            emit(state.copyWith(status: ReportGenerationStatus.success, message: 'تم إنشاء ومشاركة التقرير بنجاح.'));
          } else {
            throw Exception('فشل حفظ ملف Excel.');
          }
        } catch (e) {
          emit(state.copyWith(status: ReportGenerationStatus.failure, message: 'حدث خطأ أثناء إنشاء الملف: ${e.toString()}'));
        }
      },
    );
  }
}
