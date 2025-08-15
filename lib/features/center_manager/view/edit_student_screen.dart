
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/data/models/center_maneger/edit_student_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_details_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/edit_student_bloc/edit_student_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/filter_bloc/filter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

// لا تغيير هنا، هذا الجزء سليم
class EditStudentScreen extends StatelessWidget {
  final int studentId;
  final String studentName;

  const EditStudentScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => EditStudentBloc(
                repository: context.read<CenterManagerRepository>(),
              )..add(FetchStudentDetails(studentId)),
        ),
        BlocProvider(
          create:
              (context) => FilterBloc(
                repository: context.read<CenterManagerRepository>(),
              )..add(LoadFilterData()),
        ),
      ],
      child: EditStudentView(studentName: studentName),
    );
  }
}

class EditStudentView extends StatefulWidget {
  final String studentName;
  const EditStudentView({super.key, required this.studentName});

  @override
  State<EditStudentView> createState() => _EditStudentViewState();
}

class _EditStudentViewState extends State<EditStudentView> {
  // ==================== الإصلاح رقم 1: إضافة متغير لحالة الخطوة الحالية ====================
  int _currentStep = 0;
  // ====================================================================================

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // وحدات التحكم (لا تغيير هنا)
  late var _firstNameController = TextEditingController();
  late var _lastNameController = TextEditingController();
  late var _fatherNameController = TextEditingController();
  late var _motherNameController = TextEditingController();
  late var _birthDateController = TextEditingController();
  late var _phoneController = TextEditingController();
  late var _educationalLevelController = TextEditingController();
  late var _healthStatusController = TextEditingController();

  String? _gender;
  String? _socialStatus;
  int? _selectedHalaqaId;
  int? _selectedLevelId;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _fatherNameController = TextEditingController();
    _motherNameController = TextEditingController();
    _birthDateController = TextEditingController();
    _phoneController = TextEditingController();
    _educationalLevelController = TextEditingController();
    _healthStatusController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _educationalLevelController.dispose();
    _healthStatusController.dispose();
    super.dispose();
  }

  void _populateControllers(StudentDetails student) {
    _firstNameController.text = student.firstName;
    _lastNameController.text = student.lastName;
    _fatherNameController.text = student.fatherName ?? '';
    _motherNameController.text = student.motherName ?? '';
    _birthDateController.text = student.birthDate ?? '';
    _phoneController.text = student.phone ?? '';
    _educationalLevelController.text = student.educationaLevel ?? '';
    _healthStatusController.text = student.healthStatus ?? '';
    setState(() {
      _gender = student.gender;
      _socialStatus = student.socialStatus;
      _selectedHalaqaId = student.halaqa?.id;
      _selectedLevelId = student.level?.id;
    });
  }

  void _submitForm(BuildContext context) {
    // التحقق من صحة كلا النموذجين
    final isStep1Valid = _formKeyStep1.currentState?.validate() ?? false;
    final isStep2Valid = _formKeyStep2.currentState?.validate() ?? false;

    if (isStep1Valid && isStep2Valid) {
      print("✅ [EditStudentView] Forms are valid. Submitting data...");
      final model = EditStudentModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        fatherName: _fatherNameController.text,
        motherName: _motherNameController.text,
        birthDate: _birthDateController.text,
        gender: _gender!,
        socialStatus: _socialStatus!,
        educationaLevel: _educationalLevelController.text,
        healthStatus: _healthStatusController.text,
        contactNumber: _phoneController.text,
        halaqaId: _selectedHalaqaId!,
        levelId: _selectedLevelId!,
      );
      final studentId = context.read<EditStudentBloc>().state.student!.id;
      context.read<EditStudentBloc>().add(
        SubmitStudentUpdate(studentId: studentId, data: model),
      );
    } else {
      print("❌ [EditStudentView] Forms are not valid. Cannot submit.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تعديل: ${widget.studentName}',
          style: GoogleFonts.tajawal(),
        ),
        backgroundColor: AppColors.steel_blue,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EditStudentBloc, EditStudentState>(
            listener: (context, state) {
              if (state.status == EditStudentStatus.detailsLoaded &&
                  state.student != null) {
                _populateControllers(state.student!);
              }
              if (state.status == EditStudentStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حفظ التعديلات بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop(state.updatedStudent);
              }
              if (state.status == EditStudentStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل العملية: ${state.errorMessage}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<EditStudentBloc, EditStudentState>(
          builder: (context, editState) {
            return BlocBuilder<FilterBloc, FilterState>(
              builder: (context, filterState) {
                if (editState.status == EditStudentStatus.loadingDetails ||
                    filterState.status == FilterStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (editState.status == EditStudentStatus.failure) {
                  return Center(
                    child: Text(
                      "فشل تحميل تفاصيل الطالب: ${editState.errorMessage}",
                    ),
                  );
                }
                if (filterState.status == FilterStatus.failure) {
                  return Center(
                    child: Text(
                      "فشل تحميل بيانات الفلاتر: ${filterState.errorMessage}",
                    ),
                  );
                }
                if (editState.student != null) {
                  // ==================== الإصلاح رقم 2: تفعيل الـ Stepper بالكامل ====================
                  return Stepper(
                    type:
                        StepperType
                            .vertical, // النوع العمودي أفضل للشاشات الطويلة
                    currentStep:
                        _currentStep, // استخدام المتغير من حالة الويدجت
                    onStepTapped: (step) => setState(() => _currentStep = step),
                    onStepContinue: () {
                      final isLastStep =
                          _currentStep ==
                          _buildSteps(context, filterState).length - 1;
                      // التحقق من صحة الخطوة الحالية قبل الانتقال
                      bool isStepValid = false;
                      if (_currentStep == 0) {
                        isStepValid =
                            _formKeyStep1.currentState?.validate() ?? false;
                      } else if (_currentStep == 1) {
                        isStepValid =
                            _formKeyStep2.currentState?.validate() ?? false;
                      }

                      if (isStepValid) {
                        if (isLastStep) {
                          // إذا كانت الخطوة الأخيرة، قم بإرسال النموذج
                          _submitForm(context);
                        } else {
                          // انتقل للخطوة التالية
                          setState(() => _currentStep += 1);
                        }
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep -= 1);
                      }
                    },
                    steps: _buildSteps(context, filterState),
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child:
                            (editState.status == EditStudentStatus.submitting)
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : Row(
                                  children: [
                                    // زر التالي أو حفظ
                                    ElevatedButton(
                                      onPressed: details.onStepContinue,
                                      child: Text(
                                        _currentStep == 1
                                            ? 'حفظ التعديلات'
                                            : 'التالي',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // زر السابق (يظهر فقط بعد الخطوة الأولى)
                                    if (_currentStep > 0)
                                      TextButton(
                                        onPressed: details.onStepCancel,
                                        child: const Text('السابق'),
                                      ),
                                  ],
                                ),
                      );
                    },
                  );
                  // ====================================================================================
                }
                return const Center(child: Text("جاري تهيئة الشاشة..."));
              },
            );
          },
        ),
      ),
    );
  }

  // دالة بناء الخطوات (لا تغيير هنا)
  List<Step> _buildSteps(BuildContext context, FilterState filterState) {
    return [
      Step(
        title: const Text('المعلومات الشخصية'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeyStep1,
          child: Column(
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
                controller: _fatherNameController,
                labelText: 'اسم الأب',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _motherNameController,
                labelText: 'اسم الأم',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _birthDateController,
                labelText: 'تاريخ الميلاد',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.tryParse(_birthDateController.text) ??
                        DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (date != null)
                    _birthDateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(date);
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('بيانات إضافية وتسجيل'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeyStep2,
          child: Column(
            children: [
              CustomTextField(
                controller: _phoneController,
                labelText: 'رقم الهاتف',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _educationalLevelController,
                labelText: 'المستوى الدراسي',
                icon: Icons.school,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _healthStatusController,
                labelText: 'الحالة الصحية (اختياري)',
                icon: Icons.local_hospital,
                isRequired: false,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                items:
                    ['ذكر', 'أنثى']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _gender = value),
                decoration: const InputDecoration(
                  labelText: 'الجنس',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _socialStatus,
                items:
                    ['اعزب', 'متزوج']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _socialStatus = value),
                decoration: const InputDecoration(
                  labelText: 'الحالة الاجتماعية',
                  prefixIcon: Icon(Icons.family_restroom),
                  border: OutlineInputBorder(),
                ),
              ),
              const Divider(height: 30),
              DropdownButtonFormField<int>(
                value: _selectedHalaqaId,
                hint: const Text('اختر الحلقة'),
                items:
                    filterState.halaqas.map((halaqa) {
                      return DropdownMenuItem<int>(
                        value: halaqa['id'] as int?,
                        child: Text(halaqa['name'] as String? ?? 'غير معروف'),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _selectedHalaqaId = value),
                validator: (value) => value == null ? 'الحقل مطلوب' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bookmark_border),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedLevelId,
                hint: const Text('اختر المرحلة'),
                items:
                    filterState.levels.map((level) {
                      return DropdownMenuItem<int>(
                        value: level['id'] as int?,
                        child: Text(level['name'] as String? ?? 'غير معروف'),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _selectedLevelId = value),
                validator: (value) => value == null ? 'الحقل مطلوب' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.stairs_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
