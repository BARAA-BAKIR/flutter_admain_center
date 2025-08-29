// lib/features/center_manager/view/add_mosque_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/create_mosque_bloc/create_mosque_bloc.dart';

class AddMosqueScreen extends StatelessWidget {
  const AddMosqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // شاشة الإضافة توفر البلوك الخاص بها فقط
    return BlocProvider(
      create:
          (context) => CreateMosqueBloc(
            // هي تقرأ الـ Repository الذي تم توفيره في main.dart
            repository: context.read<CenterManagerRepository>(),
          ),
      child: const _AddMosqueForm(),
    );
  }
}

class _AddMosqueForm extends StatefulWidget {
  const _AddMosqueForm();

  @override
  State<_AddMosqueForm> createState() => _AddMosqueFormState();
}

class _AddMosqueFormState extends State<_AddMosqueForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // التحقق من صحة النموذج قبل الإرسال
    if (_formKey.currentState!.validate()) {
      final mosqueData = {
        'name': _nameController.text,
        'address': _addressController.text,
      };
      // استدعاء الحدث من البلوك
      context.read<CreateMosqueBloc>().add(CreateMosqueSubmitted(mosqueData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مسجد جديد',
        style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: BlocListener<CreateMosqueBloc, CreateMosqueState>(
        listener: (context, state) {
          if (state.status == FormStatus.submissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('تمت إضافة المسجد بنجاح!'),
                  backgroundColor: Colors.green,
                ),
              );
            // إرجاع 'true' لإعلام الشاشة السابقة بالنجاح
            Navigator.of(context).pop(true);
          }
          if (state.status == FormStatus.submissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'فشلت عملية الإضافة'),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const SizedBox(height: 20),
              _buildTextFormField(_nameController, 'اسم المسجد', Icons.mosque),
              const SizedBox(height: 20),
              _buildTextFormField(
                _addressController,
                'العنوان',
                Icons.location_on_outlined,
              ),
              const SizedBox(height: 40),
              BlocBuilder<CreateMosqueBloc, CreateMosqueState>(
                builder: (context, state) {
                  return state.status == FormStatus.submissionInProgress
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'إضافة المسجد',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _submitForm,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // نسخة محسنة من حقل الإدخال
  Widget _buildTextFormField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }
}
