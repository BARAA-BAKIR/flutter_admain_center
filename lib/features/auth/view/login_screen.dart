// lib/features/auth/view/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/teacher/view/forgot_password_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/domain/usecases/login_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/login_bloc.dart';
import 'package:flutter_admain_center/features/auth/view/registration_screen.dart';

// الخطوة 1: توفير الـ Bloc
// هذه الويدجت أصبحت الآن مسؤولة فقط عن توفير الـ Bloc
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => LoginBloc(
            // قراءة الـ Dependencies التي وفرناها في main.dart
            loginUseCase: context.read<LoginUseCase>(),
            authBloc: context.read<AuthBloc>(),
          ),
      child: const LoginView(), // عرض الواجهة الفعلية
    );
  }
}

// الخطوة 2: بناء الواجهة التفاعلية
// هذه الويدجت تحتوي على كل عناصر الواجهة ومنطقها
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // دالة لإرسال حدث تسجيل الدخول إلى الـ Bloc
  void _login(BuildContext context) {
    // التحقق من صحة الحقول أولاً
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // الخطوة 3: استخدام BlocListener للاستماع للأحداث (مثل عرض رسائل الخطأ)
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          // إخفاء أي رسالة سابقة وعرض الرسالة الجديدة
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'فشل تسجيل الدخول'),
                backgroundColor: Colors.redAccent,
              ),
            );
        }
        // لا نحتاج للاستماع لحالة النجاح هنا، لأن AuthBloc سيتولى عملية الانتقال للشاشة الرئيسية
      },
      child: Scaffold(
        backgroundColor: AppColors.ivory_yellow.withOpacity(0.5),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: size.width * 0.3,
                      color: AppColors.steel_blue,
                    ),
                    const SizedBox(height: 16),
                    // اسم المركز هنا يمكن أن يكون عاماً، وبعد الدخول يتم عرض الاسم المخصص
                    Text(
                      'إدارة المراكز القرآنية',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.night_blue,
                      ),
                    ),
                    Text(
                      'أهلاً بك مجدداً',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'البريد الإلكتروني',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator:
                          (v) =>
                              (v == null || v.isEmpty || !v.contains('@'))
                                  ? 'بريد إلكتروني غير صالح'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: GoogleFonts.tajawal(),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        labelStyle: GoogleFonts.tajawal(
                          color: AppColors.night_blue.withOpacity(0.8),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.steel_blue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.steel_blue,
                          ),
                          onPressed:
                              () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: AppColors.steel_blue,
                            width: 2,
                          ),
                        ),
                      ),
                      validator:
                          (v) =>
                              (v == null || v.isEmpty)
                                  ? 'كلمة المرور مطلوبة'
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: GoogleFonts.tajawal(
                            color: AppColors.teal_blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // الخطوة 4: استخدام BlocBuilder لجعل الزر يتفاعل مع حالة التحميل
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        // إذا كانت الحالة هي التحميل، اعرض مؤشر تحميل
                        if (state.status == LoginStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.steel_blue,
                            ),
                          );
                        }
                        // في الحالات الأخرى، اعرض الزر
                        return ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.steel_blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟',
                          style: GoogleFonts.tajawal(
                            color: Colors.grey.shade800,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegistrationScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'سجل الآن',
                            style: GoogleFonts.tajawal(
                              color: AppColors.golden_orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
