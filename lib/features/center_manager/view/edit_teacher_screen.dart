// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // ... (باقي الاستيرادات)

// class EditTeacherScreen extends StatefulWidget {
//   final int teacherId;
//   const EditTeacherScreen({super.key, required this.teacherId});

//   @override
//   State<EditTeacherScreen> createState() => _EditTeacherScreenState();
// }

// class _EditTeacherScreenState extends State<EditTeacherScreen> {
//   final _formKey = GlobalKey<FormState>();
//   // Controllers لكل حقل
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _fatherNameController = TextEditingController();
//   final _motherNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _passwordConfirmController = TextEditingController();

//   bool _isInitialDataLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<EditTeacherBloc>().add(LoadTeacherForEdit(widget.teacherId));
//   }

//   @override
//   void dispose() {
//     // ... (تخلص من كل الـ Controllers)
//     super.dispose();
//   }

//   void _populateFields(TeacherDetailsModel data) {
//     _firstNameController.text = data.firstName;
//     _lastNameController.text = data.lastName;
//     _fatherNameController.text = data.fatherName;
//     _motherNameController.text = data.motherName;
//     _phoneController.text = data.phoneNumber;
//     _emailController.text = data.email;
//     _isInitialDataLoaded = true;
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final data = {
//         'first_name': _firstNameController.text,
//         'last_name': _lastNameController.text,
//         'father_name': _fatherNameController.text,
//         'mother_name': _motherNameController.text,
//         'phone_number': _phoneController.text,
//         'email': _emailController.text,
//         if (_passwordController.text.isNotEmpty) 'password': _passwordController.text,
//         if (_passwordController.text.isNotEmpty) 'password_confirmation': _passwordConfirmController.text,
//       };
//       context.read<EditTeacherBloc>().add(SubmitTeacherUpdate(teacherId: widget.teacherId, data: data));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تعديل بيانات الأستاذ')),
//       body: BlocConsumer<EditTeacherBloc, EditTeacherState>(
//         listener: (context, state) {
//           if (state.status == EditTeacherStatus.success && state.initialData != null && _isInitialDataLoaded) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('تم التحديث بنجاح'), backgroundColor: Colors.green),
//             );
//             // إرجاع البيانات المحدثة إلى الشاشة السابقة
//             Navigator.of(context).pop(state.initialData); 
//           }
//           // ... (معالجة حالة الفشل)
//         },
//         builder: (context, state) {
//           if (state.status == EditTeacherStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state.status == EditTeacherStatus.success && !_isInitialDataLoaded && state.initialData != null) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _populateFields(state.initialData!);
//             });
//           }

//           return Form(
//             key: _formKey,
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 // بطاقة للمعلومات الشخصية
//                 _buildSectionCard(
//                   title: 'المعلومات الشخصية',
//                   child: Column(
//                     children: [
//                       CustomTextField(controller: _firstNameController, labelText: 'الاسم الأول', ...),
//                       CustomTextField(controller: _lastNameController, labelText: 'الكنية', ...),
//                       CustomTextField(controller: _fatherNameController, labelText: 'اسم الأب', ...),
//                       CustomTextField(controller: _motherNameController, labelText: 'اسم الأم', ...),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // بطاقة لمعلومات التواصل والحساب
//                 _buildSectionCard(
//                   title: 'معلومات التواصل والحساب',
//                   child: Column(
//                     children: [
//                       CustomTextField(controller: _phoneController, labelText: 'رقم الهاتف', ...),
//                       CustomTextField(controller: _emailController, labelText: 'البريد الإلكتروني', ...),
//                       const Divider(height: 32),
//                       Text('تغيير كلمة المرور (اتركه فارغاً لعدم التغيير)', style: GoogleFonts.tajawal()),
//                       const SizedBox(height: 16),
//                       CustomTextField(controller: _passwordController, labelText: 'كلمة المرور الجديدة', isPassword: true, ...),
//                       CustomTextField(controller: _passwordConfirmController, labelText: 'تأكيد كلمة المرور', isPassword: true, ...),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 ElevatedButton.icon(
//                   onPressed: state.status == EditTeacherStatus.submitting ? null : _submitForm,
//                   // ... (نفس تصميم الزر)
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//   // ... (انسخ دالة _buildSectionCard المساعدة إلى هنا)
// }
