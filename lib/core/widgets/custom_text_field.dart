import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //  تأكد من وجود هذا الاستيراد
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isRequired;
  final int? maxLines; //  إضافة maxLines

  // ==================== هنا هو الإصلاح الكامل والنهائي ====================
  final List<TextInputFormatter>? inputFormatters; //  جعله اختيارياً

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.isRequired = true,
    this.inputFormatters, //  إزالته من required
    this.maxLines = 1, //  القيمة الافتراضية هي سطر واحد
  });
  // ====================================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        readOnly: readOnly,
        onTap: onTap,
        inputFormatters: inputFormatters, //  استخدامه هنا
        maxLines: isPassword ? 1 : maxLines, //  كلمة المرور دائماً سطر واحد
        style: GoogleFonts.tajawal(),
        decoration: InputDecoration(
          labelStyle: GoogleFonts.tajawal(
            // ignore: deprecated_member_use
            color: AppColors.night_blue.withOpacity(0.8),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintStyle: GoogleFonts.tajawal(),
          labelText: labelText,
          prefixIcon: Icon(icon, color: AppColors.steel_blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
            gapPadding: 6,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
            gapPadding: 6,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.steel_blue, width: 2),
            gapPadding: 6,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
            gapPadding: 6,
          ),
        ),
        validator:
            validator ??
            (value) {
              if (!isRequired) {
                return null;
              }
              if (value == null || value.isEmpty) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            },
      ),
    );
  }
}
