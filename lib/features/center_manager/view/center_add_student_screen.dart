// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/add_student_bloc/center_add_student_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
// import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

// class CenterAddStudentScreen extends StatefulWidget {
//   const CenterAddStudentScreen({super.key});

//   @override
//   State<CenterAddStudentScreen> createState() => _CenterAddStudentScreenState();
// }

// class _CenterAddStudentScreenState extends State<CenterAddStudentScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _phoneController = TextEditingController();

//   int? _selectedHalaqaId;
//   int? _selectedLevelId;

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedHalaqaId == null || _selectedLevelId == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('الرجاء اختيار الحلقة والمرحلة')),
//         );
//         return;
//       }
//       // بناء النموذج بالبيانات الحقيقية من الحقول
//       final studentData = AddStudentModel(
//         username: _phoneController.text, // استخدام رقم الهاتف كاسم مستخدم
//         email: _emailController.text,
//         password: _passwordController.text,
//         firstName: _firstNameController.text,
//         lastName: _lastNameController.text,
//         phone: _phoneController.text,
//         halaqaId: _selectedHalaqaId!,
//         levelId: _selectedLevelId!,
//         // الحقول الأخرى يمكن تركها بقيم افتراضية أو جعلها اختيارية في النموذج
//         fatherName: "N/A", motherName: "N/A", birthDate: "2000-01-01",
//         gender: "ذكر", social_status: "اعزب", educationaLevel: "N/A",
//         healthStatus: "N/A", female_siblings_count: 0, male_siblings_count: 0,
//       );
//       context.read<CenterAddStudentBloc>().add(SubmitCenterStudentData(studentData));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CenterAddStudentBloc(
//         centerManagerRepository: RepositoryProvider.of<CenterManagerRepository>(context),
//       )..add( FetchCenterInitialData()),
//       child: BlocListener<CenterAddStudentBloc, CenterAddStudentState>(
//         listener: (context, state) {
//           if (state.status == CenterAddStudentStatus.success) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('تمت إضافة الطالب بنجاح'), backgroundColor: Colors.green),
//             );
//             Navigator.of(context).pop(true); // إرجاع true لتحديث القائمة
//           }
//           if (state.status == CenterAddStudentStatus.failure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.errorMessage ?? 'فشل إضافة الطالب'), backgroundColor: Colors.red),
//             );
//           }
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('إضافة طالب جديد للمركز', style: GoogleFonts.tajawal()),
//           ),
//           body: BlocBuilder<CenterAddStudentBloc, CenterAddStudentState>(
//             builder: (context, state) {
//               if (state.isLoadingHalaqas || state.isLoadingLevels) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: ListView(
//                     children: [
//                       Text('البيانات الأساسية للطالب', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//                       CustomTextField(controller: _firstNameController, labelText: 'الاسم الأول', icon: Icons.person, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
//                       const SizedBox(height: 16),
//                       CustomTextField(controller: _lastNameController, labelText: 'الكنية', icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
//                       const SizedBox(height: 16),
//                       CustomTextField(controller: _phoneController, labelText: 'رقم الهاتف (سيكون اسم المستخدم)', icon: Icons.phone, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
//                       const SizedBox(height: 16),
//                       CustomTextField(controller: _emailController, labelText: 'البريد الإلكتروني', icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null),
//                       const SizedBox(height: 16),
//                       CustomTextField(controller: _passwordController, labelText: 'كلمة المرور', icon: Icons.lock, isPassword: true, validator: (v) => v!.length < 8 ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل' : null),
//                       const Divider(height: 40),
//                       Text('بيانات التسجيل في الحلقة', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//                       DropdownButtonFormField<int>(
//                         value: _selectedHalaqaId,
//                         hint: const Text('اختر الحلقة'),
//                         items: state.halaqas.map((halaqa) => DropdownMenuItem(value: halaqa.id , child: Text(halaqa.name.toString()))).toList(),
//                         onChanged: (value) => setState(() => _selectedHalaqaId = value),
//                         validator: (value) => value == null ? 'الرجاء اختيار حلقة' : null,
//                         decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.bookmark_border)),
//                       ),
//                       const SizedBox(height: 16),
//                       DropdownButtonFormField<int>(
//                         value: _selectedLevelId,
//                         hint: const Text('اختر المرحلة'),
//                         items: state.levels.map((level) => DropdownMenuItem(value: level.id, child: Text(level.name.toString()))).toList(),
//                         onChanged: (value) => setState(() => _selectedLevelId = value),
//                         validator: (value) => value == null ? 'الرجاء اختيار مرحلة' : null,
//                         decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.stairs_outlined)),
//                       ),
//                       const SizedBox(height: 32),
//                       BlocBuilder<CenterAddStudentBloc, CenterAddStudentState>(
//                         builder: (context, state) {
//                           if (state.status == CenterAddStudentStatus.loading) {
//                             return const Center(child: CircularProgressIndicator());
//                           }
//                           return ElevatedButton.icon(
//                             onPressed: _submitForm,
//                             icon: const Icon(Icons.add),
//                             label: const Text('إضافة الطالب'),
//                             style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_student_bloc/center_add_student_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class CenterAddStudentScreen extends StatefulWidget {
  const CenterAddStudentScreen({super.key});

  @override
  State<CenterAddStudentScreen> createState() => _CenterAddStudentScreenState();
}

class _CenterAddStudentScreenState extends State<CenterAddStudentScreen> {
  // استخدام Stepper يتطلب GlobalKey لكل خطوة
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  // وحدات التحكم لكل الحقول
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _educationalLevelController = TextEditingController();
  final _healthStatusController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // التخلص من كل وحدات التحكم
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _educationalLevelController.dispose();
    _healthStatusController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    // التأكد من أن كل الخطوات صالحة
    final isStep1Valid = _formKeyStep1.currentState?.validate() ?? false;
    final isStep2Valid = _formKeyStep2.currentState?.validate() ?? false;
    final isStep3Valid = _formKeyStep3.currentState?.validate() ?? false;

    if (isStep1Valid && isStep2Valid && isStep3Valid) {
      final bloc = context.read<CenterAddStudentBloc>();
      final currentState = bloc.state;

      // بناء النموذج بكل البيانات
      final studentData = AddStudentModel(
        username:
            '${_firstNameController.text} ${_lastNameController.text}', // اسم المستخدم الجديد
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        fatherName: _fatherNameController.text,
        motherName: _motherNameController.text,
        birthDate: _birthDateController.text,
        gender: currentState.gender,
        phone: _phoneController.text,
        social_status: currentState.socialStatus,
        educationaLevel: _educationalLevelController.text,
        healthStatus:
            _healthStatusController.text.isNotEmpty
                ? _healthStatusController.text
                : 'لا يوجد',
        halaqaId: currentState.selectedHalaqaId!,
        levelId: currentState.selectedLevelId!,
        female_siblings_count: 0, // قيمة افتراضية
        male_siblings_count: 0, // قيمة افتراضية
      );
      print(' bloc add ');
      bloc.add(SubmitCenterStudentData(studentData));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تعبئة كل الحقول المطلوبة في جميع الخطوات'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // تم نقل BlocProvider إلى مكان الاستدعاء في students_screen.dart
    // لذلك هذه الشاشة تستهلك البلوك مباشرة
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إضافة طالب جديد',
          style: GoogleFonts.tajawal(),
          selectionColor: AppColors.light_sky_blue,
        ),
        backgroundColor: AppColors.steel_blue,
      ),
      // استخدام BlocListener للاستجابة للحالات (النجاح، الفشل) بدون إعادة بناء الواجهة
      body: BlocListener<CenterAddStudentBloc, CenterAddStudentState>(
        listener: (context, state) {
          if (state.status == CenterAddStudentStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تمت إضافة الطالب بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            // إرجاع true لإعلام الشاشة السابقة بضرورة تحديث القائمة
            Navigator.of(context).pop(true);
          }
          if (state.status == CenterAddStudentStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'فشل إضافة الطالب'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        // استخدام BlocBuilder لإعادة بناء الواجهة عند تغير الحالة (مثل التحميل أو تغير الخطوة)
        child: BlocBuilder<CenterAddStudentBloc, CenterAddStudentState>(
          builder: (context, state) {
            if (state.isLoadingHalaqas || state.isLoadingLevels) {
              return const Center(child: CircularProgressIndicator());
            }
            return Stepper(
              currentStep: state.currentStep,
              onStepTapped:
                  (step) => context.read<CenterAddStudentBloc>().add(
                    CenterStepChanged(step),
                  ),
              onStepContinue: () {
                final bloc = context.read<CenterAddStudentBloc>();
                final isLastStep =
                    state.currentStep == _buildSteps(context, state).length - 1;

                // التحقق من صحة الخطوة الحالية قبل الانتقال
                bool isStepValid = false;
                if (state.currentStep == 0)
                  isStepValid = _formKeyStep1.currentState!.validate();
                if (state.currentStep == 1)
                  isStepValid = _formKeyStep2.currentState!.validate();
                if (state.currentStep == 2)
                  isStepValid = _formKeyStep3.currentState!.validate();

                if (isStepValid) {
                  if (isLastStep) {
                    _submitForm(context);
                  } else {
                    bloc.add(CenterStepChanged(state.currentStep + 1));
                  }
                }
              },
              onStepCancel: () {
                if (state.currentStep > 0) {
                  context.read<CenterAddStudentBloc>().add(
                    CenterStepChanged(state.currentStep - 1),
                  );
                }
              },
              steps: _buildSteps(context, state),
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child:
                      state.status == CenterAddStudentStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (details.currentStep > 0)
                                TextButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text('السابق'),
                                ),
                              ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text(
                                  details.currentStep ==
                                          _buildSteps(context, state).length - 1
                                      ? 'إرسال'
                                      : 'التالي',
                                ),
                              ),
                            ],
                          ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // دالة لبناء خطوات الـ Stepper
  List<Step> _buildSteps(BuildContext context, CenterAddStudentState state) {
    return [
      Step(
        title: const Text('الشخصية'),
        isActive: state.currentStep >= 0,
        state: state.currentStep > 0 ? StepState.complete : StepState.indexed,
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
              CustomTextField(
                controller: _lastNameController,
                labelText: 'الكنية',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _fatherNameController,
                labelText: 'اسم الأب',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _motherNameController,
                labelText: 'اسم الأم',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _birthDateController,
                labelText: 'تاريخ الميلاد',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (date != null)
                    _birthDateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(date);
                },
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('التواصل'),
        isActive: state.currentStep >= 1,
        state: state.currentStep > 1 ? StepState.complete : StepState.indexed,
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
              CustomTextField(
                controller: _emailController,
                labelText: 'البريد الإلكتروني',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator:
                    (v) =>
                        v!.isEmpty || !v.contains('@')
                            ? 'بريد إلكتروني غير صالح'
                            : null,
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'كلمة المرور',
                icon: Icons.lock,
                isPassword: true,
                validator:
                    (v) =>
                        v!.length < 8
                            ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'
                            : null,
              ),
              CustomTextField(
                controller: _educationalLevelController,
                labelText: 'المستوى الدراسي',
                icon: Icons.school,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              CustomTextField(
                controller: _healthStatusController,
                labelText: 'الحالة الصحية (اختياري)',
                icon: Icons.local_hospital,
                isRequired: false,
              ),
              DropdownButtonFormField<String>(
                value: state.gender,
                items:
                    ['ذكر', 'أنثى']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => context.read<CenterAddStudentBloc>().add(
                      CenterGenderChanged(value!),
                    ),
                decoration: const InputDecoration(
                  labelText: 'الجنس',
                  prefixIcon: Icon(Icons.wc),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: state.socialStatus,
                items:
                    ['اعزب', 'متزوج']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => context.read<CenterAddStudentBloc>().add(
                      CenterSocialStatusChanged(value!),
                    ),
                decoration: const InputDecoration(
                  labelText: 'الحالة الاجتماعية',
                  prefixIcon: Icon(Icons.family_restroom),
                ),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('التسجيل'),
        isActive: state.currentStep >= 2,
        content: Form(
          key: _formKeyStep3,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                menuMaxHeight: 300.0,
                value: state.selectedHalaqaId,
                hint: const Text('اختر الحلقة'),
                items:
                    state.halaqas
                        .map(
                          (halaqa) => DropdownMenuItem(
                            value: halaqa.id,
                            child: Text(halaqa.name),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => context.read<CenterAddStudentBloc>().add(
                      CenterHalaqaChanged(value!),
                    ),
                validator:
                    (value) => value == null ? 'الرجاء اختيار حلقة' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bookmark_border),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                menuMaxHeight: 300.0,
                value: state.selectedLevelId,
                hint: const Text('اختر المرحلة'),
                items:
                    state.levels
                        .map(
                          (level) => DropdownMenuItem(
                            value: level.id,
                            child: Text(level.name),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => context.read<CenterAddStudentBloc>().add(
                      CenterLevelChanged(value!),
                    ),
                validator:
                    (value) => value == null ? 'الرجاء اختيار مرحلة' : null,
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
