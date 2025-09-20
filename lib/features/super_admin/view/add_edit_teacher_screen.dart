import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_filter_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/teacher_model.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/teacher_management_bloc/teacher_management_bloc.dart';

class AddEditTeacherScreen extends StatefulWidget {
  final Teacher? teacher;
  const AddEditTeacherScreen({super.key, this.teacher});
  bool get isEditMode => teacher != null;

  @override
  State<AddEditTeacherScreen> createState() => _AddEditTeacherScreenState();
}

class _AddEditTeacherScreenState extends State<AddEditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  DateTime? _birthDate;
  DateTime? _startDate;
  String? _gender;
  String? _status;
  int? _centerId;

  @override
  void initState() {
    super.initState();
    context.read<TeacherManagementBloc>().add(
      const FetchPrerequisitesForTeacherForm(),
    );
    _initializeControllers();
    if (widget.isEditMode) {
      _populateFieldsForEdit();
    } else {
      _gender = 'ذكر';
      _status = 'نشط';
    }
  }

  void _initializeControllers() {
    const fields = [
      'email',
      'password',
      'first_name',
      'last_name',
      'father_name',
      'mother_name',
      'phone_number',
      'address',
      'education_level',
      'memorized_parts',
      'document_number',
      'salary',
    ];
    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  void _populateFieldsForEdit() {
    final t = widget.teacher!;
    _controllers['email']?.text = t.email ?? '';
    _controllers['first_name']?.text = t.firstName ?? '';
    _controllers['last_name']?.text = t.lastName ?? '';
    _controllers['father_name']?.text = t.fatherName ?? '';
    _controllers['mother_name']?.text = t.motherName ?? '';
    _controllers['phone_number']?.text = t.phoneNumber ?? '';
    _controllers['address']?.text = t.address ?? '';
    _controllers['education_level']?.text = t.educationLevel ?? '';
    _controllers['memorized_parts']?.text = t.memorizedParts.toString();
    _controllers['document_number']?.text = t.documentNumber ?? '';
    _controllers['salary']?.text = t.salary?.toString() ?? '';
    _birthDate = t.birthDate;
    _startDate = t.startDate;
    _gender = t.gender;
    _status = t.status;
    _centerId = t.centerId;
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();

    // ✅ الإصلاح: استدعاء .validate() هو الإجراء الوحيد المطلوب للتحقق
    if (_formKey.currentState!.validate()) {
      // إذا كان النموذج صالحاً، قم ببناء البيانات
      final data = {
        'email': _controllers['email']!.text,
        'first_name': _controllers['first_name']!.text,
        'last_name': _controllers['last_name']!.text,
        'father_name': _controllers['father_name']!.text,
        'mother_name': _controllers['mother_name']!.text,
        'phone_number': _controllers['phone_number']!.text,
        'address': _controllers['address']!.text,
        'education_level': _controllers['education_level']!.text,
        'document_number': _controllers['document_number']!.text,
        'salary':
            _controllers['salary']!.text.isNotEmpty
                ? double.tryParse(_controllers['salary']!.text)
                : null,
        'memorized_parts':
            int.tryParse(_controllers['memorized_parts']!.text) ?? 0,
        'birth_date': DateFormat('yyyy-MM-dd').format(_birthDate!),
        'start_date': DateFormat('yyyy-MM-dd').format(_startDate!),
        'gender': _gender,
        'status': _status,
        'center_id': _centerId,
      };

      if (_controllers['password']!.text.isNotEmpty) {
        data['password'] = _controllers['password']!.text;
      }

      if (widget.isEditMode) {
        context.read<TeacherManagementBloc>().add(
          UpdateTeacher(teacherId: widget.teacher!.id, data: data),
        );
      } else {
        context.read<TeacherManagementBloc>().add(AddTeacher(data: data));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'تعديل بيانات الأستاذ' : 'إضافة أستاذ جديد',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<TeacherManagementBloc, TeacherManagementState>(
        listener: (context, state) {
          if (state.formStatus == FormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.isEditMode ? 'تم التحديث بنجاح' : 'تمت الإضافة بنجاح',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(microseconds: 100), () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop(true);
              }
            });
          } else if (state.formStatus == FormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'فشل العملية: ${state.formError ?? 'خطأ غير معروف'}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoadingPrerequisites) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionCard('بيانات الحساب', [
                  TextFormField(
                    controller: _controllers['email'],
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'البريد الإلكتروني مطلوب';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                        return 'صيغة البريد الإلكتروني غير صحيحة';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _controllers['password'],
                    decoration: const InputDecoration(
                      labelText: 'كلمة المرور',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (widget.isEditMode && (value == null || value.isEmpty))
                        return null;
                      if (value == null || value.isEmpty)
                        return 'كلمة المرور مطلوبة';
                      if (value.length < 8)
                        return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
                      return null;
                    },
                  ),
                  if (widget.isEditMode)
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'اترك كلمة المرور فارغة لعدم تغييرها',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                ]),
                _buildSectionCard('البيانات الشخصية', [
                  _buildTextField(
                    'first_name',
                    'الاسم الأول',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    'last_name',
                    'الكنية',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    'father_name',
                    'اسم الأب',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    'mother_name',
                    'اسم الأم',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    'phone_number',
                    'رقم الهاتف',
                    keyboardType: TextInputType.phone,
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    'address',
                    'العنوان التفصيلي',
                    validator: _validateRequired,
                  ),
                  _buildDateField(
                    'تاريخ الميلاد',
                    _birthDate,
                    (date) => setState(() => _birthDate = date),
                  ),
                  _buildDropdownField<String>('الجنس', _gender, [
                    'ذكر',
                    'انثى',
                  ], (val) => setState(() => _gender = val)),
                ]),
                _buildSectionCard('البيانات الوظيفية', [
                  _buildTextField(
                    'education_level',
                    'المستوى التعليمي',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    'memorized_parts',
                    'الأجزاء المحفوظة',
                    keyboardType: TextInputType.number,
                    validator: _validateInteger,
                  ),
                  _buildTextField(
                    'document_number',
                    'رقم الوثيقة',
                    validator: _validateRequired,
                  ),
                  _buildTextField(
                    'salary',
                    'الراتب',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _validateNumber,
                  ),
                  _buildDateField(
                    'تاريخ المباشرة',
                    _startDate,
                    (date) => setState(() => _startDate = date),
                  ),
                  _buildDropdownField<String>('الحالة', _status, [
                    'نشط',
                    'غير نشط',
                  ], (val) => setState(() => _status = val)),
                  _buildCentersDropdown(state.centersList),
                ]),
                const SizedBox(height: 20),
                BlocBuilder<TeacherManagementBloc, TeacherManagementState>(
                  builder: (context, state) {
                    return state.formStatus == FormStatus.submitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Text(
                            widget.isEditMode
                                ? 'حفظ التغييرات'
                                : 'إضافة الأستاذ',
                          ),
                        );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- دوال البناء والمساعدة (لا تغيير هنا) ---

  Widget _buildSectionCard(String title, List<Widget> children) => Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children.map(
            (c) =>
                Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
          ),
        ],
      ),
    ),
  );

  TextFormField _buildTextField(
    String key,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: _controllers[key],
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    keyboardType: keyboardType,
    validator: validator,
  );

  Widget _buildDateField(
    String label,
    DateTime? date,
    Function(DateTime) onDateSelected,
  ) => TextFormField(
    readOnly: true,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      suffixIcon: const Icon(Icons.calendar_today),
    ),
    controller: TextEditingController(
      text: date != null ? DateFormat('yyyy-MM-dd').format(date) : '',
    ),
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) onDateSelected(picked);
    },
    validator:
        (value) => (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
  );

  Widget _buildDropdownField<T>(
    String label,
    T? value,
    List<T> items,
    Function(T?) onChanged,
  ) => DropdownButtonFormField<T>(
    value: value,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    items:
        items
            .map(
              (item) =>
                  DropdownMenuItem(value: item, child: Text(item.toString())),
            )
            .toList(),
    onChanged: (val) => setState(() => onChanged(val)),
    validator: (value) => value == null ? 'الرجاء اختيار قيمة' : null,
  );

  Widget _buildCentersDropdown(List<CenterFilterModel> centers) =>
      DropdownButtonFormField<int>(
        value: _centerId,
        hint: const Text('اختر المركز'),
        isExpanded: true,
        items:
            centers
                .map(
                  (center) => DropdownMenuItem<int>(
                    value: center.id,
                    child: Text(center.name),
                  ),
                )
                .toList(),
        onChanged: (value) => setState(() => _centerId = value),
        validator: (value) => value == null ? 'الرجاء اختيار مركز' : null,
        decoration: const InputDecoration(
          labelText: 'المركز',
          border: OutlineInputBorder(),
        ),
      );

  // --- دوال التحقق (لا تغيير هنا) ---

  String? _validateRequired(String? value) =>
      (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null;
  String? _validateInteger(String? value) =>
      (value == null || value.isEmpty)
          ? 'هذا الحقل مطلوب'
          : int.tryParse(value) == null
          ? 'الرجاء إدخال رقم صحيح'
          : null;
  String? _validateNumber(String? value) =>
      (value == null || value.isEmpty)
          ? 'هذا الحقل مطلوب'
          : double.tryParse(value) == null
          ? 'الرجاء إدخال رقم صحيح'
          : null;
}
