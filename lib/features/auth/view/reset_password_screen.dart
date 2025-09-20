import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_admain_center/features/auth/bloc/reset_password/reset_password_bloc.dart';
import 'package:flutter_admain_center/features/auth/view/login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String token;
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.token,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    // توفير البلوك لهذه الشاشة
    return BlocProvider(
      create: (context) => ResetPasswordBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: ResetPasswordView(token: token, email: email),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  final String token;
  final String email;

  const ResetPasswordView({
    super.key,
    required this.token,
    required this.email,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // إرسال الحدث إلى البلوك مع كل البيانات المطلوبة
      context.read<ResetPasswordBloc>().add(
            ResetPasswordSubmitted(
              email: widget.email,
              token: widget.token,
              password: _passwordController.text,
              passwordConfirmation: _confirmPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('إعادة تعيين كلمة المرور', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // إخفاء سهم الرجوع
      ),
      body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            // عند النجاح، عرض رسالة والانتقال إلى شاشة الدخول
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تغيير كلمة المرور بنجاح! يمكنك الآن تسجيل الدخول.'),
                backgroundColor: Colors.green,
              ),
            );
            // الانتقال إلى شاشة الدخول واستبدال كل الشاشات السابقة
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          } else if (state is ResetPasswordFailure) {
            // عند الفشل، عرض رسالة الخطأ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل التحديث: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.key_rounded, size: 80, color: AppColors.teal_blue),
                  const SizedBox(height: 20),
                  Text(
                    'أدخل كلمة المرور الجديدة',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.night_blue),
                  ),
                  const SizedBox(height: 30),
                  // حقل كلمة المرور الجديدة
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الجديدة',

                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        gapPadding: 6),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
                      if (value.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // حقل تأكيد كلمة المرور
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        gapPadding: 6
                        ,borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) return 'كلمتا المرور غير متطابقتين';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  // زر الحفظ
                  BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is ResetPasswordLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.steel_blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: state is ResetPasswordLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              )
                            : Text('حفظ كلمة المرور الجديدة', style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
