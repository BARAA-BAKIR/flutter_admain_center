
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// تأكد من صحة هذه المسارات
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_halaqa_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_selection_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_selection_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/edit_halaqa_bloc/edit_halaqa_bloc.dart';

class EditHalaqaScreen extends StatefulWidget {
  final int halaqaId;
  const EditHalaqaScreen({super.key, required this.halaqaId});

  @override
  State<EditHalaqaScreen> createState() => _EditHalaqaScreenState();
}

class _EditHalaqaScreenState extends State<EditHalaqaScreen> {
  // مفتاح النموذج ووحدات التحكم تبقى كما هي
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _workingDaysController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // طلب البيانات الأولية عند بناء الشاشة
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
    // التحقق من صحة الحقول قبل الإرسال
    if (_formKey.currentState?.validate() ?? false) {
      final state = context.read<EditHalaqaBloc>().state;
      final halaqaData = AddHalaqaModel(
        name: _nameController.text,
        masjidId: state.selectedMosque!.id,
        halaqaTypeId: state.selectedHalaqaType!['id'],
        teacherId: state.selectedTeacher?.id,
        workingDays: _workingDaysController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text.isNotEmpty ? _endDateController.text : null,
      );
      context.read<EditHalaqaBloc>().add(SubmitHalaqaUpdate(halaqaId: widget.halaqaId, halaqaData: halaqaData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام لون خلفية هادئ واحترافي
      backgroundColor: AppColors.light_gray,
      appBar: AppBar(
        title: Text('تعديل الحلقة', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.night_blue, // لون احترافي
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: BlocListener<EditHalaqaBloc, EditHalaqaState>(
        listener: (context, state) {
          // عرض رسالة خطأ عند الفشل
          if (state.status == EditHalaqaStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('فشل: ${state.errorMessage ?? "خطأ غير معروف"}'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
          // عرض رسالة نجاح وإغلاق الشاشة عند اكتمال التحديث
          if (state.status == EditHalaqaStatus.success && state.initialHalaqaData == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث الحلقة بنجاح'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(true);
          }
        },
        child: BlocBuilder<EditHalaqaBloc, EditHalaqaState>(
          buildWhen: (p, c) => p.status != c.status,
          builder: (context, state) {
            // عرض مؤشر التحميل
            if (state.status == EditHalaqaStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            // عرض رسالة خطأ إذا فشل التحميل الأولي
            if (state.status == EditHalaqaStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 50),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? 'فشل تحميل البيانات'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<EditHalaqaBloc>().add(LoadAllEditData(widget.halaqaId)),
                      child: const Text('إعادة المحاولة'),
                    )
                  ],
                ),
              );
            }

            // تعبئة الحقول مرة واحدة بعد تحميل البيانات بنجاح
            if (state.initialHalaqaData != null && _nameController.text.isEmpty) {
              final data = state.initialHalaqaData!;
              final halaqa = data['halaqa'] as Map<String, dynamic>;
              final progress = data['progress'] as Map<String, dynamic>?;
              _nameController.text = halaqa['name'] ?? '';
              if (progress != null) {
                _workingDaysController.text = progress['working_days'] ?? '';
                _startDateController.text = progress['start_date'] ?? '';
                _endDateController.text = progress['end_date'] ?? '';
              }
            }

            // بناء الواجهة الرئيسية بعد تحميل البيانات
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        _buildSectionCard(
                          title: 'البيانات الأساسية للحلقة',
                          child: _buildHalaqaFields(),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionCard(
                          title: 'إسناد مشرف',
                          child: _buildTeacherSection(),
                        ),
                      ],
                    ),
                  ),
                  _buildSubmitButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildHalaqaFields() {
    return BlocBuilder<EditHalaqaBloc, EditHalaqaState>(
      buildWhen: (p, c) => p.selectedMosque != c.selectedMosque || p.selectedHalaqaType != c.selectedHalaqaType,
      builder: (context, state) {
        return Column(
          children: [
            CustomTextField(controller: _nameController, labelText: 'اسم الحلقة', icon: Icons.bookmark_border, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
            const SizedBox(height: 16),
            _buildDropdown<MosqueSelectionModel>(
              value: state.selectedMosque,
              hint: 'اختر المسجد',
              items: state.availableMosques,
              onChanged: (value) => context.read<EditHalaqaBloc>().add(SelectionChanged(selectedMosque: value)),
              validator: (value) => value == null ? 'يجب اختيار المسجد' : null,
              icon: Icons.mosque,
              itemName: (mosque) => mosque.name,
            ),
            const SizedBox(height: 16),
            _buildDropdown<Map<String, dynamic>>(
              value: state.selectedHalaqaType,
              hint: 'اختر نوع الحلقة',
              items: state.halaqaTypes,
              onChanged: (value) => context.read<EditHalaqaBloc>().add(SelectionChanged(selectedHalaqaType: value)),
              validator: (value) => value == null ? 'يجب اختيار نوع الحلقة' : null,
              icon: Icons.category_outlined,
              itemName: (type) => type['name'],
            ),
          ],
        );
      },
    );
  }

  /// بناء قسم اختيار المشرف وحقوله
  Widget _buildTeacherSection() {
    return BlocBuilder<EditHalaqaBloc, EditHalaqaState>(
      buildWhen: (p, c) => p.selectedTeacher != c.selectedTeacher,
      builder: (context, state) {
        return Column(
          children: [
            _buildDropdown<TeacherSelectionModel>(
              value: state.selectedTeacher,
              hint: 'اختر الأستاذ المشرف (اختياري)',
              items: state.availableTeachers,
              onChanged: (value) => context.read<EditHalaqaBloc>().add(SelectionChanged(selectedTeacher: value, unselectTeacher: value == null)),
              icon: Icons.school_outlined,
              itemName: (teacher) => teacher.name,
            ),
            // تأثير ظهور الحقول عند اختيار مشرف
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: state.selectedTeacher != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: state.selectedTeacher != null
                    ? _buildTeacherFields(context, true)
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// بناء حقول المشرف (أيام الدوام، التواريخ)
  Widget _buildTeacherFields(BuildContext context, bool isTeacherSelected) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          CustomTextField(controller: _workingDaysController, labelText: 'أيام الدوام', icon: Icons.calendar_view_week_outlined, validator: (v) => (isTeacherSelected && v!.isEmpty) ? 'الحقل مطلوب' : null),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _startDateController,
            labelText: 'تاريخ بدء الإشراف',
            icon: Icons.event_available,
            readOnly: true,
            onTap: () => _pickDate(context, _startDateController),
            validator: (v) => (isTeacherSelected && v!.isEmpty) ? 'الحقل مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            isRequired: false,
            controller: _endDateController,
            labelText: 'تاريخ انتهاء الإشراف (اختياري)',
            icon: Icons.event_busy,
            readOnly: true,
            onTap: () => _pickDate(context, _endDateController),
          ),
        ],
      ),
    );
  }

  /// بناء زر الحفظ في الأسفل
  Widget _buildSubmitButton() {
    return BlocBuilder<EditHalaqaBloc, EditHalaqaState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: state.status == EditHalaqaStatus.submitting ? null : _submitForm,
            icon: state.status == EditHalaqaStatus.submitting ? const SizedBox.shrink() : const Icon(Icons.save_alt_rounded),
            label: state.status == EditHalaqaStatus.submitting
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Text('حفظ التعديلات', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.night_blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
          ),
        );
      },
    );
  }

  /// بناء ويدجت Dropdown بشكل عام
  Widget _buildDropdown<T>({required T? value, required String hint, required List<T> items, required void Function(T?) onChanged, String? Function(T?)? validator, required IconData icon, required String Function(T) itemName}) {
    return DropdownButtonFormField<T>(
      
      value: value,
      hint: Text(hint, style: GoogleFonts.tajawal()),
      isExpanded: true,
      items: items.map((item) => DropdownMenuItem<T>(value: item, child: Text(itemName(item), style: GoogleFonts.tajawal(), overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        helperText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: AppColors.steel_blue),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  /// بناء الكرت الذي يحتوي على الأقسام
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 8),
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

  /// دالة مساعدة لاختيار التاريخ
  Future<void> _pickDate(BuildContext context, TextEditingController controller) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }
}

// إضافة AnimatedVisibility إلى pubspec.yaml إذا لم تكن موجودة
// flutter pub add animated_visibility
// هذا ليس حزمة حقيقية، بل خطأ شائع. AnimatedVisibility هي ويدجت مدمجة.
// إذا واجهت خطأ، تأكد من أنك تستخدم إصدار Flutter حديث.
// إذا لم تكن موجودة، يمكن استخدام AnimatedSize و AnimatedOpacity معًا.
// الكود أعلاه يستخدم AnimatedVisibility التي هي جزء من Flutter SDK.
