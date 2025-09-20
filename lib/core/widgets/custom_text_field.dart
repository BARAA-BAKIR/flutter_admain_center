import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

// 1. تحويل الويدجت إلى StatefulWidget
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isRequired;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

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
    this.inputFormatters,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

// 2. إنشاء كلاس الـ State لإدارة حالة رؤية كلمة المرور
class _CustomTextFieldState extends State<CustomTextField> {
  // متغير حالة لتتبع الرؤية
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    // عند بناء الويدجت، تكون كلمة المرور مخفية إذا كان الحقل من نوع كلمة مرور
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        // استخدام المتغيرات من الويدجت الأصلية عبر `widget.`
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        // 3. ربط خاصية إخفاء النص بمتغير الحالة
        obscureText: _isObscured,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        style: GoogleFonts.tajawal(),
        decoration: InputDecoration(
          labelStyle: GoogleFonts.tajawal(
            color: AppColors.night_blue.withOpacity(0.8),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintStyle: GoogleFonts.tajawal(),
          labelText: widget.labelText,
          prefixIcon: Icon(widget.icon, color: AppColors.steel_blue),
          
          // 4. إضافة أيقونة العين بشكل ديناميكي
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    // تغيير شكل الأيقونة بناءً على الحالة
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // 5. عند الضغط، قم بعكس حالة الرؤية
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null, // إذا لم يكن حقل كلمة مرور، لا تظهر أيقونة

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
        validator: widget.validator ??
            (value) {
              if (!widget.isRequired) {
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
