import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/teacher/bloc/changed_password/change_password_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController     = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // شريط السحب
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Text(
          'تغيير كلمة المرور',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _PasswordField(
                controller: _currentController,
                label: 'كلمة المرور الحالية',
                icon: Icons.lock,
                validator: (v) => (v == null || v.isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              _PasswordField(
                controller: _newController,
                label: 'كلمة المرور الجديدة',
                icon: Icons.lock_outline,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'مطلوب';
                  if (v.length < 8) return 'يجب ألا تقل عن 8 أحرف';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _PasswordField(
                controller: _confirmController,
                label: 'تأكيد كلمة المرور',
                icon: Icons.lock_outline,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'مطلوب';
                  if (v != _newController.text) return 'غير متطابقة';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                listener: (ctx, state) {
                  if (state is ChangePasswordSuccess) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
                    );
                  } else if (state is ChangePasswordFailure) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (ctx, state) {
                  final isLoading = state is ChangePasswordLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              ctx.read<ChangePasswordBloc>().add(
                                    ChangePasswordSubmitted(
                                      current: _currentController.text,
                                      newPassword: _newController.text,
                                      confirm: _confirmController.text,
                                    ),
                                  );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('حفظ التغييرات', style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
