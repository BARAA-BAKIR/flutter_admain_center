
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/domain/usecases/login_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/login_bloc.dart';
import 'package:flutter_admain_center/features/auth/view/registration_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        loginUseCase: context.read<LoginUseCase>(),
      ),
      child: const LoginView(),
    );
  }
}

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

  void _submitLogin() {
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

    // ✅ الحل: قمنا بإزالة كود التوجيه من هنا
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success && state.user != null) {
          // فقط قم بإعلام AuthBloc، وهو سيقوم بتفعيل التوجيه في AppContent
          context.read<AuthBloc>().add(LoggedIn(user: state.user!));
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'فشل تسجيل الدخول'),
                backgroundColor: Colors.redAccent,
              ),
            );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.light_sky_blue.withOpacity(0.9),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.night_blue,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'البريد الإلكتروني',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || v.isEmpty || !v.contains('@'))
                          ? 'الرجاء إدخال بريد إلكتروني صالح'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: GoogleFonts.tajawal(),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        labelStyle: GoogleFonts.tajawal(color: AppColors.night_blue.withOpacity(0.8)),
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.steel_blue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.steel_blue,
                          ),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: AppColors.steel_blue, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'كلمة المرور مطلوبة' : null,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                        ),
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: GoogleFonts.tajawal(
                            color: AppColors.steel_blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state.status == LoginStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(color: AppColors.steel_blue),
                          );
                        }
                        return ElevatedButton(
                          onPressed: _submitLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.steel_blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ليس لديك حساب؟',
                         style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800)),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                          ),
                          child: Text(
                            'سجل الآن',
                            style: GoogleFonts.tajawal(
                              color: AppColors.dark_teal_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
