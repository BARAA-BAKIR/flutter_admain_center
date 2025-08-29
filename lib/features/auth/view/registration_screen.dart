
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// استيراد الطبقات والبلوكات اللازمة
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/teacher/registration_model.dart';
import 'package:flutter_admain_center/domain/usecases/get_centers_usecase.dart';
import 'package:flutter_admain_center/domain/usecases/register_teacher_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/registration_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/registration_event.dart';
import 'package:flutter_admain_center/features/auth/bloc/registration_state.dart';

// --- الطبقة الأولى: ويدجت لتوفير الـ Bloc ---
// هذه الويدجت مسؤولة فقط عن إنشاء وتوفير RegistrationBloc للشجرة أسفلها.
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(
        // قراءة الاعتماديات (UseCases و AuthBloc) التي وفرناها في main.dart
        registerTeacherUseCase: context.read<RegisterTeacherUseCase>(),
        getCentersUseCase: context.read<GetCentersUseCase>(),
        authBloc: context.read<AuthBloc>(),
      )..add(FetchCenters()), // ..add() لجلب المراكز فور إنشاء الـ Bloc مباشرة
      child: const RegistrationView(), // عرض الواجهة الفعلية
    );
  }
}

// --- الطبقة الثانية: ويدجت الواجهة الفعلية ---
// هذه هي الواجهة التي يراها المستخدم، وهي الآن منفصلة عن منطق الإنشاء.
class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  // --- كل الكود الخاص بالحالة والـ Controllers موجود هنا ---
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = 'ذكر';
  final _educationLevelController = TextEditingController();
  final _startDateController = TextEditingController();
  int? _selectedCenter;
  final _salaryController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _memorizedPartsController = TextEditingController();

  // تم حذف initState من هنا لأن FetchCenters يتم استدعاؤه عند إنشاء الـ Bloc

  @override
  void dispose() {
    // التخلص من كل وحدات التحكم
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _educationLevelController.dispose();
    _startDateController.dispose();
    _salaryController.dispose();
    _documentNumberController.dispose();
    _memorizedPartsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('إنشاء حساب أستاذ', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.status == RegistrationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage ?? 'تم إرسال الطلب بنجاح'), backgroundColor: Colors.green),
            );
            // عند النجاح، AuthBloc سيتولى الانتقال للشاشة الرئيسية،
            // ولكن يمكننا إغلاق هذه الشاشة إذا فُتحت فوق شاشة أخرى.
            // if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            // }
          }
          if(state.successMessage=='تم تسجيل الأستاذ بنجاح وفي انتظار موافقة الإدارة.')
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage ?? 'تم إرسال الطلب بنجاح'), backgroundColor: Colors.green),
            );
            // عند النجاح، AuthBloc سيتولى الانتقال للشاشة الرئيسية،
            // ولكن يمكننا إغلاق هذه الشاشة إذا فُتحت فوق شاشة أخرى.
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
          if (state.status == RegistrationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ ما'), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            // إذا كانت الحالة هي التحميل العام (بعد الضغط على إرسال)، نعرض مؤشر تحميل
            if (state.status == RegistrationStatus.loading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.steel_blue));
            }

            // الواجهة الرئيسية (Stepper)
            return Stepper(
              type: StepperType.horizontal,
              currentStep: state.currentStep,
              onStepContinue: () {
                final bloc = context.read<RegistrationBloc>();
                bool isStepValid = false;
                // التحقق من صحة الحقول في الخطوة الحالية فقط
                if (bloc.state.currentStep == 0) isStepValid = _formKeyStep1.currentState!.validate();
                if (bloc.state.currentStep == 1) isStepValid = _formKeyStep2.currentState!.validate();
                if (bloc.state.currentStep == 2) isStepValid = _formKeyStep3.currentState!.validate();

                if (isStepValid) {
                  final isLastStep = bloc.state.currentStep == _buildSteps(state).length - 1;
                  if (isLastStep) {
                    // التأكد من أن كل النماذج صالحة قبل الإرسال
                    if (_formKeyStep1.currentState!.validate() && _formKeyStep2.currentState!.validate() && _formKeyStep3.currentState!.validate()) {
                      _submitRegistration(context);
                    }
                  } else {
                    bloc.add(StepChanged(bloc.state.currentStep + 1));
                  }
                }
              },
              onStepCancel: () {
                final bloc = context.read<RegistrationBloc>();
                if (bloc.state.currentStep > 0) {
                  bloc.add(StepChanged(bloc.state.currentStep - 1));
                }
              },
              steps: _buildSteps(state),
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      if (details.currentStep > 0)
                        TextButton(onPressed: details.onStepCancel, child: Text('السابق', style: GoogleFonts.tajawal(color: Colors.grey.shade700))),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.steel_blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          details.currentStep == _buildSteps(state).length - 1 ? 'إرسال الطلب' : 'التالي',
                          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
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

  List<Step> _buildSteps(RegistrationState state) {
    return [
      Step(
        title: Text('الحساب', style: GoogleFonts.tajawal()),
        content: Form(key: _formKeyStep1, child: _buildStep1Content()),
        isActive: state.currentStep >= 0,
      ),
      Step(
        title: Text('الشخصية', style: GoogleFonts.tajawal()),
        content: Form(key: _formKeyStep2, child: _buildStep2Content()),
        isActive: state.currentStep >= 1,
      ),
      Step(
        title: Text('الوظيفة', style: GoogleFonts.tajawal()),
        content: Form(key: _formKeyStep3, child: _buildStep3Content(state)), // تمرير الحالة هنا
        isActive: state.currentStep >= 2,
      ),
    ];
  }

  Widget _buildStep1Content() {
    return Column(children: [
      CustomTextField(controller: _firstNameController, labelText: 'الاسم الأول', icon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
      CustomTextField(controller: _lastNameController, labelText: 'الكنية', icon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
      CustomTextField(
        controller: _emailController,
        labelText: 'البريد الإلكتروني',
        icon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        validator: (v) => (v == null || v.isEmpty || !v.contains('@')) ? 'بريد إلكتروني غير صالح' : null,
      ),
      CustomTextField(
        controller: _passwordController,
        labelText: 'كلمة المرور',
        icon: Icons.lock_outline,
        isPassword: true,
        validator: (v) => (v == null || v.length < 8) ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل' : null,
      ),
      CustomTextField(
        controller: _confirmPasswordController,
        labelText: 'تأكيد كلمة المرور',
        icon: Icons.lock_outline,
        isPassword: true,
        validator: (v) => (v != _passwordController.text) ? 'كلمتا المرور غير متطابقتين' : null,
      ),
    ]);
  }

  Widget _buildStep2Content() {
    return Column(children: [
      CustomTextField(controller: _fatherNameController, labelText: 'اسم الأب', icon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
      CustomTextField(controller: _motherNameController, labelText: 'اسم الأم', icon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
      CustomTextField(
        controller: _birthDateController,
        labelText: 'تاريخ الميلاد',
        icon: Icons.calendar_today_outlined,
        readOnly: true,
        onTap: () async {
          DateTime? date = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now());
          if (date != null) _birthDateController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        },
        validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
      CustomTextField(controller: _phoneController, labelText: 'رقم الهاتف', icon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
      CustomTextField(controller: _addressController, labelText: 'العنوان التفصيلي', icon: Icons.home_outlined, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text('الجنس:', style: GoogleFonts.tajawal(fontSize: 16, color: AppColors.night_blue)),
          Row(children: [Radio<String>(value: 'ذكر', groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)), Text('ذكر', style: GoogleFonts.tajawal())]),
          Row(children: [Radio<String>(value: 'أنثى', groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)), Text('أنثى', style: GoogleFonts.tajawal())]),
        ]),
      ),
    ]);
  }

  Widget _buildStep3Content(RegistrationState state) {
    return Column(children: [
      CustomTextField(controller: _educationLevelController, labelText: 'المستوى التعليمي', icon: Icons.school_outlined, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
      CustomTextField(
        controller: _startDateController,
        labelText: 'تاريخ بدء العمل',
        icon: Icons.work_history_outlined,
        readOnly: true,
        onTap: () async {
          DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
          if (date != null) _startDateController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        },
        validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
      if (state.isLoadingCenters)
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        )
      else
        DropdownButtonFormField<int>(
          value: _selectedCenter,
          hint: Text('اختر المركز', style: GoogleFonts.tajawal()),
          items: state.centers.map((center) {
            return DropdownMenuItem<int>(
              value: center.id,
              child: Text(center.name, style: GoogleFonts.tajawal()),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedCenter = value),
          validator: (value) => value == null ? 'الرجاء اختيار مركز' : null,
        ),
      CustomTextField(controller: _documentNumberController, labelText: 'رقم الوثيقة', icon: Icons.badge_outlined, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
      CustomTextField(controller: _memorizedPartsController, labelText: 'عدد الأجزاء المحفوظة', icon: Icons.menu_book_outlined, keyboardType: TextInputType.number, validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null),
    ]);
  }

  void _submitRegistration(BuildContext context) {
    final registrationModel = RegistrationModel(
      name:'${_firstNameController.text} ${_lastNameController.text}',
      email: _emailController.text,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      fatherName: _fatherNameController.text,
      motherName: _motherNameController.text,
      birthDate: _birthDateController.text,
      educationLevel: _educationLevelController.text,
      startDate: _startDateController.text,
      centerId: _selectedCenter!,
      salary: double.tryParse(_salaryController.text) ?? 0.0,
      documentNumber: _documentNumberController.text,
      gender: _gender,
      phone: _phoneController.text,
      address: _addressController.text,
      memorizedParts: int.tryParse(_memorizedPartsController.text) ?? 0,
    );

    context.read<RegistrationBloc>().add(SubmitRegistration(registrationModel));
  }
}
