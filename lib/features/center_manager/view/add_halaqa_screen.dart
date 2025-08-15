import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_halaqa_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_selection_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_selection_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_halaqa_bloc/add_halaqa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddHalaqaScreen extends StatefulWidget {
  const AddHalaqaScreen({super.key});

  @override
  State<AddHalaqaScreen> createState() => _AddHalaqaScreenState();
}

class _AddHalaqaScreenState extends State<AddHalaqaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _workingDaysController = TextEditingController();
  final _startDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AddHalaqaBloc>().add(LoadHalaqaPrerequisites());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _workingDaysController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<AddHalaqaBloc>().state;
      final halaqaData = AddHalaqaModel(
        name: _nameController.text,
        masjidId: state.selectedMosque!.id,
        halaqaTypeId: state.selectedHalaqaType!['id'],
        teacherId: state.selectedTeacher?.id,
        workingDays: state.selectedTeacher != null ? _workingDaysController.text : null,
        startDate: state.selectedTeacher != null ? _startDateController.text : null,
      );
      context.read<AddHalaqaBloc>().add(SubmitNewHalaqa(halaqaData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('إضافة حلقة جديدة', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<AddHalaqaBloc, AddHalaqaState>(
        listener: (context, state) {
          if (state.status == AddHalaqaStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إنشاء الحلقة بنجاح'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(true);
          }
          if (state.status == AddHalaqaStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل: ${state.errorMessage ?? "خطأ غير معروف"}'), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<AddHalaqaBloc, AddHalaqaState>(
          builder: (context, state) {
            if (state.status == AddHalaqaStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSectionCard(
                    title: 'البيانات الأساسية للحلقة',
                    child: Column(
                      children: [
                        CustomTextField(controller: _nameController, labelText: 'اسم الحلقة', icon: Icons.bookmark_border, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
                        const SizedBox(height: 16),
                        _buildDropdown<MosqueSelectionModel>(
                          value: state.selectedMosque,
                          hint: 'اختر المسجد',
                          items: state.availableMosques,
                          onChanged: (value) => context.read<AddHalaqaBloc>().add(AddHalaqaSelectionChanged(selectedMosque: value)),
                          validator: (value) => value == null ? 'يجب اختيار المسجد' : null,
                          icon: Icons.mosque,
                          itemName: (mosque) => mosque.name,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown<Map<String, dynamic>>(
                          value: state.selectedHalaqaType,
                          hint: 'اختر نوع الحلقة',
                          items: state.halaqaTypes,
                          onChanged: (value) => context.read<AddHalaqaBloc>().add(AddHalaqaSelectionChanged(selectedHalaqaType: value)),
                          validator: (value) => value == null ? 'يجب اختيار نوع الحلقة' : null,
                          icon: Icons.category_outlined,
                          itemName: (type) => type['name'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    title: 'إسناد مشرف (اختياري)',
                    child: Column(
                      children: [
                        _buildDropdown<TeacherSelectionModel>(
                          value: state.selectedTeacher,
                          hint: 'اختر الأستاذ المشرف',
                          items: state.availableTeachers,
                          onChanged: (value) {
                            context.read<AddHalaqaBloc>().add(AddHalaqaSelectionChanged(
                                selectedTeacher: value,
                                unselectTeacher: value == null,
                              ));
                          },
                          icon: Icons.school_outlined,
                          itemName: (teacher) => teacher.name,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: state.selectedTeacher != null ? _buildTeacherFields(state) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: state.status == AddHalaqaStatus.submitting ? null : _submitForm,
                    icon: state.status == AddHalaqaStatus.submitting ? const SizedBox.shrink() : const Icon(Icons.add_circle_outline),
                    label: state.status == AddHalaqaStatus.submitting
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : Text('إنشاء الحلقة', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal_blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTeacherFields(AddHalaqaState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          CustomTextField(
            controller: _workingDaysController,
            labelText: 'أيام الدوام',
            icon: Icons.calendar_view_week_outlined,
            validator: (v) => (state.selectedTeacher != null && v!.isEmpty) ? 'الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _startDateController,
            labelText: 'تاريخ بدء الإشراف',
            icon: Icons.event_available,
            readOnly: true,
            onTap: () async {
              DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
              if (date != null) _startDateController.text = DateFormat('yyyy-MM-dd').format(date);
            },
            validator: (v) => (state.selectedTeacher != null && v!.isEmpty) ? 'الحقل مطلوب' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({required T? value, required String hint, required List<T> items, required void Function(T?) onChanged, String? Function(T?)? validator, required IconData icon, required String Function(T) itemName}) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint, style: GoogleFonts.tajawal()),
      items: items.map((item) => DropdownMenuItem<T>(value: item, child: Text(itemName(item), style: GoogleFonts.tajawal()))).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: AppColors.steel_blue),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue)),
            const Divider(height: 24, thickness: 0.5),
            child,
          ],
        ),
      ),
    );
  }
}
