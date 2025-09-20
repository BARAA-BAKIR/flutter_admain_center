// // lib/core/theme/app_theme.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';

// class AppTheme {
//   // وضع التصميم الفاتح (الرئيسي)
//   static ThemeData get lightTheme {
//     return ThemeData(
//       // 1. نظام الألوان (ColorScheme)
//       // هذا هو الجزء الأهم الذي يحدد ألوان معظم الويدجتس
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: AppColors.night_blue, // اللون الأساسي الذي تتولد منه باقي الألوان
//         primary: AppColors.night_blue,    // اللون الرئيسي للأزرار، AppBar، الخ.
//         secondary: AppColors.steel_blue,  // لون ثانوي للعناصر التفاعلية
//         // ignore: deprecated_member_use
//         background: AppColors.light_gray, // لون خلفية الشاشات (رمادي فاتح جداً)
//         surface: AppColors.white,        // لون خلفية الكروت والحاويات
//         error: Colors.red.shade700,       // لون للأخطاء
//         onPrimary: AppColors.white,       // لون النصوص والأيقونات فوق اللون الرئيسي (أبيض)
//         onSecondary: AppColors.white,     // لون النصوص فوق اللون الثانوي
//         // ignore: deprecated_member_use
//         onBackground: AppColors.dark_gray,// لون النصوص على الخلفية الرئيسية
//         onSurface: AppColors.black,       // لون النصوص على الكروت
//       ),

//       // 2. تصميم شريط العنوان (AppBar)
//       // "خلي العنوان عريض ابيض"
//       appBarTheme: const AppBarTheme(
//         backgroundColor: AppColors.night_blue, // لون الخلفية أزرق داكن
//         foregroundColor: AppColors.light_gray,      // لون الأيقونات والنص الافتراضي (أبيض)
//         elevation: 2.0,                        // ظل خفيف لإعطاء عمق
//         centerTitle: true,                     // توسيط العنوان
//         titleTextStyle: TextStyle(
//           color: AppColors.white,              // لون نص العنوان (أبيض)
//           fontSize: 20.0,                      // حجم الخط
//           fontWeight: FontWeight.bold,         // **خط عريض**
//           fontFamily: 'Cairo', // يمكنك تحديد خط معين إذا أضفته للمشروع
//         ),
//       ),

//       // 3. تصميم حقول الإدخال (InputDecorationTheme)
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.white,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: const BorderSide(color: AppColors.gray),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: const BorderSide(color: AppColors.gray),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: const BorderSide(color: AppColors.night_blue, width: 2.0),
//         ),
//         labelStyle: const TextStyle(color: AppColors.dark_gray),
//         hintStyle: const TextStyle(color: AppColors.gray),
//       ),

//       // 4. تصميم الأزرار (ElevatedButton)
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.night_blue, // لون خلفية الزر
//           foregroundColor: AppColors.white,      // لون النص والأيقونة
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
//           textStyle: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Cairo',
//           ),
//         ),
//       ),

//       // 5. تصميم الكروت (Card)
//       cardTheme: CardTheme(
//         elevation: 1.0,
//         color: AppColors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//       ),

//       // 6. استخدام الخطوط
//       // يفضل إضافة خط عربي جميل مثل 'Cairo' إلى مشروعك عبر pubspec.yaml
//       fontFamily: 'Cairo',

//       // 7. تفعيل Material 3 لتصميم عصري
//       useMaterial3: true,
//     );
//   }
// }
