import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/profile_boc/profile_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/edit_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    
    // حفظ نسخة من ProfileBloc قبل الدخول في الحوار
    final profileBloc = context.read<ProfileBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        // لا حاجة لـ BlocProvider.value هنا لأننا سنستخدم المتغير المحفوظ
        return BlocConsumer<ProfileBloc, ProfileState>(
          bloc: profileBloc, // استخدام البلوك المحفوظ
          listener: (context, state) {
            if (state.status == ProfileStatus.passwordVerified) {
              Navigator.of(dialogContext).pop(); // أغلق الحوار أولاً

              // ✅✅ الحل هنا: تمرير البلوك بشكل صريح إلى الشاشة التالية ✅✅
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: profileBloc, // مرر نسخة البلوك
                    child: const EditProfileScreen(),
                  ),
                ),
              );
            } else if (state.status == ProfileStatus.failure) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.errorMessage ?? 'كلمة المرور غير صحيحة'),
                    backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: const Text('التحقق الأمني'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('لتعديل ملفك الشخصي، يرجى إدخال كلمة المرور الحالية.'),
                const SizedBox(height: 16),
                TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'كلمة المرور'),
                    autocorrect: false),
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('إلغاء')),
                ElevatedButton(
                  onPressed: state.status == ProfileStatus.submitting
                      ? null
                      : () {
                          if (passwordController.text.isNotEmpty) {
                            profileBloc.add(PasswordVerifiedForEdit(
                                password: passwordController.text));
                          }
                        },
                  child: state.status == ProfileStatus.submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 3))
                      : const Text('تحقق'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي',
        style:TextStyle(fontWeight:FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            style: ButtonStyle(),
            icon: const Icon(Icons.edit_note),
            tooltip: 'تعديل الملف الشخصي',
            onPressed: () => _showPasswordDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // ... (باقي كود بناء الواجهة كما هو، فهو صحيح)
          if (state.status == ProfileStatus.loading || state.status == ProfileStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProfileStatus.failure && state.userProfile == null) {
            return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));
          }
          if (state.userProfile == null) {
            return const Center(child: Text('لا توجد بيانات لعرضها.'));
          }

          final profile = state.userProfile!;
          final employee = profile.employee;
          final admin = employee?.employeeadmin;

          return RefreshIndicator(
            onRefresh: () async => context.read<ProfileBloc>().add(ProfileFetched()),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildInfoCard('معلومات الحساب', [
                  _buildInfoRow(Icons.badge_outlined, 'الاسم الكامل', profile.name),
                  _buildInfoRow(Icons.email_outlined, 'البريد الإلكتروني', profile.email),
                ]),
                if (employee != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoCard('المعلومات الشخصية', [
                    _buildInfoRow(Icons.person_outline, 'الاسم الأول', employee.firstName),
                    _buildInfoRow(Icons.people_outline, 'اسم العائلة', employee.lastName),
                    _buildInfoRow(Icons.person_pin_outlined, 'اسم الأب', employee.fatherName),
                    _buildInfoRow(Icons.person_pin_circle_outlined, 'اسم الأم', employee.motherName),
                    _buildInfoRow(Icons.cake_outlined, 'تاريخ الميلاد', employee.birthDate),
                    _buildInfoRow(Icons.phone_outlined, 'رقم الهاتف', employee.phoneNumber),
                    _buildInfoRow(Icons.location_on_outlined, 'العنوان', employee.address),
                    _buildInfoRow(Icons.article_outlined, 'رقم الوثيقة', employee.documentNumber),
                    _buildInfoRow(employee.gender == 'ذكر' ? Icons.male_outlined : Icons.female_outlined, 'الجنس', employee.gender),
                  ]),
                ],
                if (admin != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoCard('معلومات الدور الإداري', [
                    _buildInfoRow(Icons.admin_panel_settings_outlined, 'الدور الإداري', admin.administrativeRole),
                    _buildInfoRow(admin.status == 'نشط' ? Icons.check_circle_outline : Icons.cancel_outlined, 'الحالة', admin.status,
                        valueColor: admin.status == 'نشط' ? Colors.green.shade700 : Colors.red.shade700),
                  ]),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // واجهات مساعدة لتحسين المظهر
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Text(
            '$label: ',
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.tajawal(
                fontSize: 15,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}