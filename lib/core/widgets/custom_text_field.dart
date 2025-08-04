// lib/core/widgets/custom_text_field.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// تأكد من أن هذا المسار صحيح في مشروعك
import 'package:flutter_admain_center/core/constants/app_colors.dart'; 

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  
  // --- الإضافات الجديدة ---
  final String? Function(String?)? validator; // 1. لدعم التحقق المخصص
  final bool readOnly;                         // 2. لجعله للقراءة فقط (مثل حقل التاريخ)
  final VoidCallback? onTap;                   // 3. لتنفيذ دالة عند الضغط (لفتح منتقي التاريخ)
  final bool isRequired;                       // 4. لتحديد ما إذا كان الحقل مطلوباً أم لا

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    // --- الإضافات الجديدة في الـ constructor ---
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.isRequired = true, // بشكل افتراضي، كل الحقول مطلوبة
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        readOnly: readOnly, // استخدام الخاصية الجديدة
        onTap: onTap,       // استخدام الخاصية الجديدة
        style: GoogleFonts.tajawal(), // تطبيق الخط على النص المدخل
        decoration: InputDecoration(
          // استخدام الخط في عنوان الحقل
          // ignore: deprecated_member_use
          labelStyle: GoogleFonts.tajawal(color: AppColors.night_blue.withOpacity(0.8)),
          hintStyle: GoogleFonts.tajawal(),
          labelText: labelText,
          prefixIcon: Icon(icon, color: AppColors.steel_blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.steel_blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
        // --- التعديل الرئيسي هنا: منطق التحقق المرن ---
        validator: validator ?? (value) {
          // إذا كان الحقل غير مطلوب، لا تقم بالتحقق إذا كان فارغاً
          if (!isRequired) {
            return null; 
          }
          // التحقق الافتراضي للحقول المطلوبة
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
      ),
    );
  }
}
