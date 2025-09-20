import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_details_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_list_model.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/all_students_bloc/all_students_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddEditStudentScreen extends StatefulWidget {
  final StudentListItem? student;
  const AddEditStudentScreen({super.key, this.student});
  bool get isEditMode => student != null;

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  String? _gender;
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // عند بدء الشاشة، نطلب من الـ BLoC تحميل كل البيانات اللازمة
    context.read<AllStudentsBloc>().add(
      LoadDataForStudentForm(studentId: widget.student?.id),
    );
  }

  void _initializeControllers() {
    const fields = [
      'name',
      'email',
      'password',
      'first_name',
      'last_name',
      'father_name',
      'mother_name',
      'contact_number',
      'education_level',
      'health_status',
      'social_status',
      'male_siblings_count',
      'female_siblings_count',
    ];
    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  // يتم استدعاء هذه الدالة من الـ listener لتعبئة حقول النص فقط
  void _populateTextFields(StudentDetails details) {
    _controllers['name']!.text = details.name ?? '';
    _controllers['email']!.text = details.email ?? '';
    _controllers['first_name']!.text = details.firstName ?? '';
    _controllers['last_name']!.text = details.lastName ?? '';
    _controllers['father_name']!.text = details.fatherName ?? '';
    _controllers['mother_name']!.text = details.motherName ?? '';
    _controllers['contact_number']!.text = details.contactNumber ?? '';
    _controllers['education_level']!.text = details.educationLevel ?? '';
    _controllers['health_status']!.text = details.healthStatus ?? '';
    _controllers['social_status']!.text = details.socialStatus ?? '';
    _controllers['male_siblings_count']!.text =
        (details.maleSiblingsCount ?? 0).toString();
    _controllers['female_siblings_count']!.text =
        (details.femaleSiblingsCount ?? 0).toString();
  }

  void _submitForm(AllStudentsState currentState) {
    // التحقق من صحة كل الحقول قبل الإرسال
    if (!_formKey.currentState!.validate()) return;

    final data = <String, dynamic>{
      'name': _controllers['name']!.text,
      'email': _controllers['email']!.text,
      'first_name': _controllers['first_name']!.text,
      'last_name': _controllers['last_name']!.text,
      'father_name': _controllers['father_name']!.text,
      'mother_name': _controllers['mother_name']!.text,
      'contact_number': _controllers['contact_number']!.text,
      'education_level': _controllers['education_level']!.text,
      'health_status': _controllers['health_status']!.text,
      'social_status': _controllers['social_status']!.text,
      'male_siblings_count': _controllers['male_siblings_count']!.text,
      'female_siblings_count': _controllers['female_siblings_count']!.text,
      'gender': currentState.selectedGender,
      'is_one_parent_deceased': currentState.isOneParentDeceased,
      'birth_date':
          currentState.selectedBirthDate != null
              ? DateFormat('yyyy-MM-dd').format(currentState.selectedBirthDate!)
              : null,
      'halaqa_id': currentState.selectedHalaqaId,
      'level_id': currentState.selectedLevelId,
    };

    if (_controllers['password']!.text.isNotEmpty) {
      data['password'] = _controllers['password']!.text;
    }

    if (widget.isEditMode) {
      context.read<AllStudentsBloc>().add(
        UpdateStudentDetails(studentId: widget.student!.id, data: data),
      );
    } else {
      context.read<AllStudentsBloc>().add(AddNewStudent(data: data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'تعديل بيانات الطالب' : 'إضافة طالب جديد',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AllStudentsBloc, AllStudentsState>(
        listenWhen:
            (prev, curr) =>
                prev.formStatus != curr.formStatus ||
                (widget.isEditMode &&
                    prev.studentDetails == null &&
                    curr.studentDetails != null),
        listener: (context, state) {
          if (state.formStatus == FormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تمت العملية بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state.formStatus == FormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'حدث خطأ غير متوقع'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (widget.isEditMode && state.studentDetails != null) {
            _populateTextFields(state.studentDetails!);
          }
        },
        builder: (context, state) {
          if (state.formStatus == FormStatus.loading ||
              state.formStatus == FormStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    title: 'معلومات الحساب',
                    icon: Icons.account_circle_outlined,
                    children: [
                      _buildTextField('name', 'اسم المستخدم'),
                      _buildTextField(
                        'email',
                        'البريد الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      _buildTextField(
                        'password',
                        'كلمة المرور',
                        isPassword: true,
                        isRequired: !widget.isEditMode,
                        validator: _validatePasswordForAdd,
                      ),
                    ],
                  ),
                  _buildSectionCard(
                    title: 'المعلومات الشخصية',
                    icon: Icons.person_outline,
                    children: [
                      _buildTextField('first_name', 'الاسم الأول'),
                      _buildTextField('last_name', 'الاسم الأخير'),
                      _buildTextField('father_name', 'اسم الأب'),
                      _buildTextField('mother_name', 'اسم الأم'),
                      _buildDatePicker(context, state),
                      _buildGenderDropdown(state),
                    ],
                  ),
                  _buildSectionCard(
                    title: 'التسجيل والتعليم',
                    icon: Icons.school_outlined,
                    children: [
                      _buildCentersDropdown(state),
                      const SizedBox(height: 16),
                      _buildHalaqasDropdown(state),
                      const SizedBox(height: 16),
                      _buildLevelsDropdown(state),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'education_level',
                        'المستوى التعليمي',
                        isRequired: false,
                      ),
                    ],
                  ),
                  _buildSectionCard(
                    title: 'معلومات إضافية',
                    icon: Icons.info_outline,
                    children: [
                      _buildTextField(
                        'contact_number',
                        'رقم التواصل',
                        keyboardType: TextInputType.phone,
                      ),
                      _buildTextField(
                        'health_status',
                        'الحالة الصحية',
                        isRequired: false,
                      ),
                    
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'male_siblings_count',
                              'الإخوة الذكور',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'female_siblings_count',
                              'الإخوة الإناث',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SwitchListTile(
                        title: const Text('أحد الوالدين متوفى؟'),
                        value: state.isOneParentDeceased,
                        onChanged:
                            (value) => context.read<AllStudentsBloc>().add(
                              FormValueChanged(isOneParentDeceased: value),
                            ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed:
                        state.formStatus == FormStatus.submitting
                            ? null
                            : () => _submitForm(state),
                    icon:
                        state.formStatus == FormStatus.submitting
                            ? const SizedBox.shrink()
                            : const Icon(Icons.save_alt_rounded),
                    label:
                        state.formStatus == FormStatus.submitting
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              widget.isEditMode
                                  ? 'حفظ التعديلات'
                                  : 'إضافة الطالب',
                            ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- ويدجتات البناء المحسّنة ---

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  Widget _buildTextField(
    String key,
    String label, {
    bool isPassword = false,
    bool isRequired = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: _inputDecoration(label),
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator ?? (isRequired ? _validateRequired : null),
      ),
    );
  }

  Widget _buildCentersDropdown(AllStudentsState state) {
    return DropdownButtonFormField<int?>(
      value: state.selectedCenterId,
      hint: const Text('اختر المركز'),
      items:
          (state.filterCenters)
              .map(
                (center) => DropdownMenuItem<int?>(
                  value: center.id,
                  child: Text(center.name),
                ),
              )
              .toList(),
      onChanged: (value) {
        context.read<AllStudentsBloc>().add(CenterSelected(value));
      },
      decoration: _inputDecoration('المركز'),
      validator: (value) => value == null ? 'الرجاء اختيار مركز' : null,
    );
  }

  Widget _buildHalaqasDropdown(AllStudentsState state) {
    return DropdownButtonFormField<int?>(
      value: state.selectedHalaqaId,
      hint: Text(
        state.selectedCenterId == null ? 'اختر مركزاً أولاً' : 'اختر الحلقة',
      ),
      items:
          (state.filterHalaqas)
              .map(
                (halaqa) => DropdownMenuItem<int?>(
                  value: halaqa['id'] as int,
                  child: Text(halaqa['name'].toString()),
                ),
              )
              .toList(),
      onChanged:
          state.selectedCenterId == null
              ? null
              : (value) {
                context.read<AllStudentsBloc>().add(
                  FormValueChanged(halaqaId: value),
                );
              },
      decoration: _inputDecoration('الحلقة'),
      validator:
          (value) =>
              state.selectedCenterId != null && value == null
                  ? 'الرجاء اختيار حلقة'
                  : null,
    );
  }

  Widget _buildLevelsDropdown(AllStudentsState state) {
    return DropdownButtonFormField<int?>(
      value: state.selectedLevelId,
      hint: const Text('اختر المستوى'),
      items:
          (state.progressStages)
              .map(
                (level) => DropdownMenuItem<int?>(
                  value: level['id'] as int,
                  child: Text(level['stage_name'].toString()),
                ),
              )
              .toList(),
      onChanged: (value) {
        context.read<AllStudentsBloc>().add(FormValueChanged(levelId: value));
      },
      decoration: _inputDecoration('المستوى'),
      validator: (value) => value == null ? 'الرجاء اختيار مستوى' : null,
    );
  }

  Widget _buildDatePicker(BuildContext context, AllStudentsState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: state.selectedBirthDate ?? DateTime(2000),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            context.read<AllStudentsBloc>().add(
              FormValueChanged(birthDate: pickedDate),
            );
          }
        },
        child: InputDecorator(
          decoration: _inputDecoration('تاريخ الميلاد'),
          child: Text(
            state.selectedBirthDate != null
                ? DateFormat('yyyy-MM-dd').format(state.selectedBirthDate!)
                : 'لم يتم التحديد',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(AllStudentsState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: state.selectedGender,
        items:
            ['ذكر', 'انثى']
                .map(
                  (gender) => DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  ),
                )
                .toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<AllStudentsBloc>().add(
              FormValueChanged(gender: value),
            );
          }
        },
        decoration: _inputDecoration('الجنس'),
      ),
    );
  }

  String? _validateRequired(String? value) =>
      (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null;
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  String? _validatePasswordForAdd(String? value) {
    if (widget.isEditMode) return null;
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (value.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
    return null;
  }
}
