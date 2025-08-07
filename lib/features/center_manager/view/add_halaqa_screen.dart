import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_halaqa_bloc/add_halaqa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class AddHalaqaScreen extends StatefulWidget {
  const AddHalaqaScreen({super.key});

  @override
  State<AddHalaqaScreen> createState() => _AddHalaqaScreenState();
}

class _AddHalaqaScreenState extends State<AddHalaqaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mosqueController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedTeacherId;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_formKey.currentState!.validate()) {
        final data = {
          'name': _nameController.text,
          'masjid_name': _mosqueController.text,
          'teacher_id': _selectedTeacherId,
          'description': _descriptionController.text,
        };
        context.read<AddHalaqaBloc>().add(SubmitNewHalaqa(data));
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('جاري إنشاء الحلقة...')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddHalaqaBloc, AddHalaqaState>(
      listener: (context, state) {
        if (state.status == AddHalaqaStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء الحلقة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          // إرسال true عند العودة لإعلام الشاشة السابقة بضرورة تحديث القائمة
          Navigator.of(context).pop(true);
        }
        // ... (معالجة حالة الفشل)
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('إضافة حلقة جديدة', style: GoogleFonts.tajawal()),
          backgroundColor: AppColors.steel_blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: BlocBuilder<AddHalaqaBloc, AddHalaqaState>(
              builder: (context, state) {
                if (state.status == AddHalaqaStatus.loading &&
                    state.availableTeachers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'اسم الحلقة',
                      icon: Icons.bookmark,
                      validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _mosqueController,
                      labelText: 'اسم المسجد',
                      icon: Icons.mosque,
                      validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    // TODO: استبدال هذا بـ DropdownButtonFormField حقيقي مع قائمة الأساتذة
                    DropdownButtonFormField<int>(
                      value: _selectedTeacherId,
                      hint: const Text('اختر الأستاذ المشرف'),
                      items:
                          state.availableTeachers.map((teacher) {
                            return DropdownMenuItem<int>(
                              value: teacher['id'],
                              child: Text(
                                teacher['name'],
                              ), // افترض أن الـ API يرجع 'id' و 'name'
                            );
                          }).toList(),

                      onChanged: (value) {
                        setState(() {
                          _selectedTeacherId = value;
                        });
                      },
                      validator:
                          (value) => value == null ? 'يجب اختيار مشرف' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _descriptionController,
                      labelText: 'وصف قصير (اختياري)',
                      icon: Icons.description,
                      isRequired: false,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('إنشاء الحلقة'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
