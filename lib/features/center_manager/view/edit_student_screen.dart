import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_model.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/bloc/edit_student_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
// ملاحظة: سنحتاج لإنشاء BLoC خاص بهذه الشاشة لاحقاً

class EditStudentScreen extends StatefulWidget {
  final Student student;
  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.student.firstName,
    );
    _lastNameController = TextEditingController(text: widget.student.lastName);
    //_phoneController = TextEditingController(text: widget.student.);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // ====================  هنا هو الإصلاح ====================
      final dataToUpdate = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone': _phoneController.text,
      };
      context.read<EditStudentBloc>().add(
        SubmitStudentUpdate(studentId: widget.student.id, data: dataToUpdate),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('جاري حفظ التعديلات...')));
      // =======================================================
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => EditStudentBloc(
            repository: RepositoryProvider.of<CenterManagerRepository>(context),
          ),
      child: BlocListener<EditStudentBloc, EditStudentState>(
        listener: (context, state) {
          if (state.status == EditStudentStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حفظ التعديلات بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            // إرجاع الطالب المحدث إلى الشاشة السابقة
            Navigator.of(context).pop(state.updatedStudent);
          }
          if (state.status == EditStudentStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل الحفظ: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'تعديل بيانات: ${widget.student.fullName}',
              style: GoogleFonts.tajawal(),
            ),
            backgroundColor: AppColors.steel_blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomTextField(
                    controller: _firstNameController,
                    labelText: 'الاسم الأول',
                    icon: Icons.person,
                    validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _lastNameController,
                    labelText: 'الكنية',
                    icon: Icons.person_outline,
                    validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'رقم الهاتف',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('حفظ التعديلات'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
