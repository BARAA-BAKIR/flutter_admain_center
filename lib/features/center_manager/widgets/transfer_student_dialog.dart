import 'package:flutter/material.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/transfer_student_bloc/transfer_student_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferStudentDialog extends StatelessWidget {
  final int studentId;
  final String studentName;
  final int? currentHalaqaId;

  const TransferStudentDialog({
    super.key,
    required this.studentId,
    required this.studentName,
    this.currentHalaqaId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferStudentBloc(
        repository: context.read<CenterManagerRepository>(),
      )..add(LoadHalaqasForTransfer()),
      child: _TransferStudentDialogView(
        studentId: studentId,
        studentName: studentName,
        currentHalaqaId: currentHalaqaId,
      ),
    );
  }
}

class _TransferStudentDialogView extends StatefulWidget {
  final int studentId;
  final String studentName;
  final int? currentHalaqaId;

  const _TransferStudentDialogView({
    required this.studentId,
    required this.studentName,
    this.currentHalaqaId,
  });

  @override
  __TransferStudentDialogViewState createState() => __TransferStudentDialogViewState();
}

class __TransferStudentDialogViewState extends State<_TransferStudentDialogView> {
  int? _selectedHalaqaId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferStudentBloc, TransferStudentState>(
      listener: (context, state) {
        if (state.status == TransferStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم نقل الطالب بنجاح'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(state.updatedStudent);
        }
        if (state.status == TransferStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'فشل النقل'), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        // نعود إلى استخدام AlertDialog مباشرة كما كان
        return AlertDialog(
          title: Text('نقل الطالب: ${widget.studentName}', style: GoogleFonts.tajawal()),
          content: _buildContent(state),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: (state.status == TransferStatus.loaded && _selectedHalaqaId != null)
                  ? () {
                      context.read<TransferStudentBloc>().add(
                            TransferStudentSubmitted(
                              studentId: widget.studentId,
                              newHalaqaId: _selectedHalaqaId!,
                            ),
                          );
                    }
                  : null,
              child: const Text('تأكيد النقل'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(TransferStudentState state) {
    if (state.status == TransferStatus.loading || state.status == TransferStatus.initial) {
      return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
    }
    if (state.status == TransferStatus.submitting) {
      return const SizedBox(height: 100, child: Center(child: Text('جاري النقل...')));
    }
    if (state.status == TransferStatus.failure && state.halaqas.isEmpty) {
      return Text('فشل تحميل الحلقات: ${state.errorMessage}');
    }

    final filteredHalaqas = state.halaqas.where((halaqa) => halaqa['id'] != widget.currentHalaqaId).toList();

    if (filteredHalaqas.isEmpty) {
      return const SizedBox(height: 100, child: Center(child: Text('لا توجد حلقات أخرى متاحة.')));
    }

    return DropdownButtonFormField<int>(
      value: _selectedHalaqaId,
      hint: const Text('اختر الحلقة الجديدة'),
      isExpanded: true,
      // ==================== هنا هو الحل الصحيح والنهائي ====================
      // نحدد أقصى ارتفاع للقائمة، وإذا تجاوزته سيظهر شريط تمرير
      menuMaxHeight: 300.0, // يمكنك تعديل هذا الارتفاع حسب ما تراه مناسباً
      // ====================================================================
      items: filteredHalaqas.map((halaqa) {
        return DropdownMenuItem<int>(
          value: halaqa['id'],
          child: Text(halaqa['name']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedHalaqaId = value;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار حلقة' : null,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
