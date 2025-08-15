import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_halaqa_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_selection_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_selection_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/edit_halaqa_bloc/edit_halaqa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditHalaqaScreen extends StatefulWidget {
  final int halaqaId;
  const EditHalaqaScreen({super.key, required this.halaqaId});

  @override
  State<EditHalaqaScreen> createState() => _EditHalaqaScreenState();
}

class _EditHalaqaScreenState extends State<EditHalaqaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _workingDaysController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  //  العودة لاستخدام متغيرات الحالة المحلية
  TeacherSelectionModel? _selectedTeacher;
  MosqueSelectionModel? _selectedMosque;
  Map<String, dynamic>? _selectedHalaqaType;

  @override
  void initState() {
    super.initState();
    context.read<EditHalaqaBloc>().add(LoadAllEditData(widget.halaqaId));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _workingDaysController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final halaqaData = AddHalaqaModel(
        name: _nameController.text,
        masjidId: _selectedMosque!.id,
        halaqaTypeId: _selectedHalaqaType!['id'],
        teacherId: _selectedTeacher?.id,
        workingDays: _workingDaysController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
      );
      context.read<EditHalaqaBloc>().add(SubmitHalaqaUpdate(halaqaId: widget.halaqaId, halaqaData: halaqaData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('تعديل الحلقة', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<EditHalaqaBloc, EditHalaqaState>(
        listener: (context, state) {
          if (state.status == EditHalaqaStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل: ${state.errorMessage ?? "خطأ غير معروف"}'), backgroundColor: Colors.red),
            );
          }

          if (state.status == EditHalaqaStatus.success && state.initialHalaqaData == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث الحلقة بنجاح'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(true);
          }

          //  هذا هو المنطق الصحيح لتعبئة البيانات
          if (state.status == EditHalaqaStatus.success && state.initialHalaqaData != null) {
            final data = state.initialHalaqaData!;
            final halaqa = data['halaqa'];
            final progress = data['progress'];

            _nameController.text = halaqa['name'] ?? '';
            
            // تحديث متغيرات الحالة المحلية مباشرة
            final initialMosque = state.availableMosques.firstWhereOrNull((m) => m.id == halaqa['mosque_id']);
            final initialType = state.halaqaTypes.firstWhereOrNull((t) => t['id'] == halaqa['type']);
            final initialTeacher = (progress != null) ? state.availableTeachers.firstWhereOrNull((t) => t.id == progress['teacher_id']) : null;

            // استدعاء setState لإعادة بناء الواجهة بالقيم الجديدة
            setState(() {
              _selectedMosque = initialMosque;
              _selectedHalaqaType = initialType;
              _selectedTeacher = initialTeacher;
            });

            if (progress != null) {
              _workingDaysController.text = progress['working_days'] ?? '';
              _startDateController.text = progress['start_date'] ?? '';
              _endDateController.text = progress['end_date'] ?? '';
            }
          }
        },
        child: BlocBuilder<EditHalaqaBloc, EditHalaqaState>(
          builder: (context, state) {
            if (state.status == EditHalaqaStatus.loading || _selectedMosque == null) {
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
                          value: _selectedMosque,
                          hint: 'اختر المسجد',
                          items: state.availableMosques,
                          onChanged: (value) => setState(() => _selectedMosque = value),
                          validator: (value) => value == null ? 'يجب اختيار المسجد' : null,
                          icon: Icons.mosque,
                          itemName: (mosque) => mosque.name,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown<Map<String, dynamic>>(
                          value: _selectedHalaqaType,
                          hint: 'اختر نوع الحلقة',
                          items: state.halaqaTypes,
                          onChanged: (value) => setState(() => _selectedHalaqaType = value),
                          validator: (value) => value == null ? 'يجب اختيار نوع الحلقة' : null,
                          icon: Icons.category_outlined,
                          itemName: (type) => type['name'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    title: 'إسناد مشرف',
                    child: Column(
                      children: [
                        _buildDropdown<TeacherSelectionModel>(
                          value: _selectedTeacher,
                          hint: 'اختر الأستاذ المشرف (اختياري)',
                          items: state.availableTeachers,
                          onChanged: (value) => setState(() => _selectedTeacher = value),
                          icon: Icons.school_outlined,
                          itemName: (teacher) => teacher.name,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _selectedTeacher != null ? _buildTeacherFields() : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: state.status == EditHalaqaStatus.submitting ? null : () => _submitForm(),
                    icon: state.status == EditHalaqaStatus.submitting ? const SizedBox.shrink() : const Icon(Icons.save),
                    label: state.status == EditHalaqaStatus.submitting
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : Text('حفظ التعديلات', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _buildTeacherFields() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          CustomTextField(controller: _workingDaysController, labelText: 'أيام الدوام', icon: Icons.calendar_view_week_outlined, validator: (v) => (_selectedTeacher != null && v!.isEmpty) ? 'الحقل مطلوب' : null),
          const SizedBox(height: 16),
          CustomTextField(controller: _startDateController, labelText: 'تاريخ بدء الإشراف', icon: Icons.event_available, readOnly: true, onTap: () async {
            DateTime? date = await showDatePicker(context: context, initialDate: DateTime.tryParse(_startDateController.text) ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
            if (date != null) _startDateController.text = DateFormat('yyyy-MM-dd').format(date);
          }, validator: (v) => (_selectedTeacher != null && v!.isEmpty) ? 'الحقل مطلوب' : null),
          const SizedBox(height: 16),
          CustomTextField(controller: _endDateController, labelText: 'تاريخ انتهاء الإشراف (اختياري)', icon: Icons.event_busy, readOnly: true, onTap: () async {
            DateTime? date = await showDatePicker(context: context, initialDate: DateTime.tryParse(_endDateController.text) ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
            if (date != null) _endDateController.text = DateFormat('yyyy-MM-dd').format(date);
          }),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({required T? value, required String hint, required List<T> items, required void Function(T?) onChanged, String? Function(T?)? validator, required IconData icon, required String Function(T) itemName}) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint, style: GoogleFonts.tajawal()),
      isExpanded: true,
      items: items.map((item) => DropdownMenuItem<T>(value: item, child: Text(itemName(item), style: GoogleFonts.tajawal(), overflow: TextOverflow.ellipsis))).toList(),
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
