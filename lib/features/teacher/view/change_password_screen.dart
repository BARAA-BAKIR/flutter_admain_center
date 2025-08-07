import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/teacher/bloc/changed_password/change_password_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نحن بحاجة لتوفير الـ Bloc لهذه الشاشة فقط
    return BlocProvider(
      create: (context) => ChangePasswordBloc(
        // نقرأ الـ Repository الذي تم توفيره في main.dart
        repository: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: const ChangePasswordView(),
    );
  }
}

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordBloc>().add(
            ChangePasswordSubmitted(
              current: _currentPasswordController.text,
              newPassword: _newPasswordController.text,
              confirm: _confirmPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('تغيير كلمة المرور', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('تم تغيير كلمة المرور بنجاح!'),
                  backgroundColor: Colors.green,
                ),
              );
            // العودة إلى شاشة الإعدادات بعد النجاح
            Navigator.of(context).pop();
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('فشل التغيير: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // أيقونة ورسالة ترحيبية
                Icon(Icons.lock_reset_rounded, size: 80, color: AppColors.steel_blue.withOpacity(0.8)),
                const SizedBox(height: 16),
                Text(
                  'الحفاظ على أمان حسابك',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.night_blue),
                ),
                Text(
                  'أدخل كلمة المرور الحالية والجديدة لتحديث حسابك.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40),

                // حقل كلمة المرور الحالية
                _buildPasswordField(
                  controller: _currentPasswordController,
                  labelText: 'كلمة المرور الحالية',
                  isVisible: _isCurrentPasswordVisible,
                  toggleVisibility: () => setState(() => _isCurrentPasswordVisible = !_isCurrentPasswordVisible),
                  validator: (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 20),

                // حقل كلمة المرور الجديدة
                _buildPasswordField(
                  controller: _newPasswordController,
                  labelText: 'كلمة المرور الجديدة',
                  isVisible: _isNewPasswordVisible,
                  toggleVisibility: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
                    if (value.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // حقل تأكيد كلمة المرور الجديدة
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور الجديدة',
                  isVisible: _isConfirmPasswordVisible,
                  toggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  validator: (value) {
                    if (value != _newPasswordController.text) return 'كلمتا المرور غير متطابقتين';
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // زر التأكيد
               BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                  builder: (context, state) {
                    final isLoading = state is ChangePasswordLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal_blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        // يمكننا تحديد ارتفاع ثابت للزر لتجنب تغير حجمه أثناء التحميل
                        minimumSize: const Size.fromHeight(56),
                      ),
                      // ==================== هنا هو الإصلاح ====================
                      child: isLoading
                          // الحالة 1: إذا كان التحميل جارياً، اعرض مؤشر التحميل
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          // الحالة 2: إذا لم يكن هناك تحميل، اعرض الأيقونة والنص
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save),
                                const SizedBox(width: 8),
                                Text(
                                  'حفظ التغييرات',
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                      // =======================================================
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء حقول كلمة المرور لتجنب التكرار
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.tajawal(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
      validator: validator,
    );
  }
}
