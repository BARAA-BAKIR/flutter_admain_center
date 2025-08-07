import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/teacher/bloc/forgetpassword/forgot_password_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/forgetpassword/forgot_password_event.dart';
import 'package:flutter_admain_center/features/teacher/bloc/forgetpassword/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(
        RepositoryProvider.of<AuthRepository>(context),
      ),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context
          .read<ForgotPasswordBloc>()
          .add(ForgotPasswordSubmitted(email: _emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نسيت كلمة المرور', style: GoogleFonts.tajawal()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('تم الإرسال بنجاح'),
                content: const Text(
                    'إذا كان بريدك الإلكتروني مسجلاً لدينا، فستصلك رسالة تحتوي على رابط لإعادة تعيين كلمة المرور.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(); // أغلق الحوار
                      Navigator.of(context).pop(); // ارجع لشاشة الدخول
                    },
                    child: const Text('حسناً'),
                  ),
                ],
              ),
            );
          } else if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
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
                children: [
                  Icon(Icons.email_outlined, size: 100, color: AppColors.steel_blue),
                  const SizedBox(height: 20),
                  Text(
                    'أدخل بريدك الإلكتروني',
                    style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'سنرسل لك رابطاً لإعادة تعيين كلمة المرور الخاصة بك.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'الرجاء إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, state) {
                      if (state is ForgotPasswordLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('إرسال رابط إعادة التعيين'),
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
