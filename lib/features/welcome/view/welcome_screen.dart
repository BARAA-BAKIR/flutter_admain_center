// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/features/welcome/view_model/welcome_view_model.dart';
// import 'package:google_fonts/google_fonts.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   Future<void> _register(BuildContext context) async {
//    // final token = await AuthStorage.getUserToken();
//     //final isLoggedIn = token != null && token.isNotEmpty;

//     Navigator.of(context).pushNamed('/register');
//   }
//  Future<void> _login(BuildContext context) async {
//    // final token = await AuthStorage.getUserToken();
//     //final isLoggedIn = token != null && token.isNotEmpty;

//     Navigator.of(context).pushNamed('main/teacher');
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.light_blue,
//       body: Column(
//         children: [
//           // الجزء العلوي: الشعار وخلفية متدرجة
//           Expanded(
//             flex: 2,
//             child: Stack(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [AppColors.dark_teal_blue, AppColors.teal_blue],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(50),
//                       bottomRight: Radius.circular(50),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                     tag: "logo_info",
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: AppColors.ivory_yellow,
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: ClipOval(
//                         child: WelcomeViewModel.image,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // الجزء السفلي: النصوص والأزرار
//           Expanded(
//             flex: 3,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     WelcomeViewModel.welcomeMessage,
//                     style: GoogleFonts.tajawal(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.dark_teal_blue,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     WelcomeViewModel.subMessage,
//                     style: GoogleFonts.tajawal(
//                       fontSize: 16,
//                       color: AppColors.steel_blue,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.teal_blue2,
//                       foregroundColor: AppColors.ivory_yellow,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 50, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onPressed: () => _login(context),
//                     child: Text(
//                       'الدخول',
//                       style: GoogleFonts.tajawal(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.teal_blue2,
//                       foregroundColor: AppColors.ivory_yellow,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 50, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onPressed: () => _register(context),
//                     child: Text(
//                       'التسجيل',
//                       style: GoogleFonts.tajawal(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     WelcomeViewModel.ayah,
//                     style: GoogleFonts.amiri(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.night_blue,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// In lib/features/welcome/view/welcome_screen.dart
// In lib/features/welcome/view/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/auth/view/login_screen.dart';
import 'package:flutter_admain_center/features/auth/view/registration_screen.dart';
import 'package:flutter_admain_center/features/welcome/view_model/welcome_view_model.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

// استخدام StatefulWidget لإضافة حركات بسيطة عند ظهور الشاشة
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegistrationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام لون خلفية واحد أنيق
      backgroundColor: const Color(0xFFF0F4F8), // أزرق فاتح جداً مائل للرمادي
      body: Column(
        children: [
          // 1. الجزء العلوي: تصميم جديد وأنيق
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.steel_blue, AppColors.teal_blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Center(
                child: Container(
                 // padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 1,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: SizedBox(
                       width: 300, // <-- اضبط العرض المطلوب
                      height: 200, // <-- اضبط الارتفاع المطلوب
                      child: WelcomeViewModel.image,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. الجزء السفلي: محتوى متحرك وأنيق
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      Text(
                        WelcomeViewModel.welcomeMessage,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.night_blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        WelcomeViewModel.subMessage,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                      const Spacer(flex: 3),

                      // زر تسجيل الدخول
                      ElevatedButton(
                        onPressed: () => _navigateToLogin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.steel_blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          shadowColor: AppColors.steel_blue.withOpacity(0.4),
                        ),
                        child: Text(
                          'تسجيل الدخول',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // زر إنشاء حساب
                      OutlinedButton(
                        onPressed: () => _navigateToRegister(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.steel_blue,
                          side: const BorderSide(
                            color: AppColors.steel_blue,
                            width: 2,
                          ),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'إنشاء حساب جديد',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),

                      // الآية الكريمة
                      Text(
                        WelcomeViewModel.ayah,
                        style: GoogleFonts.amiri(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.teal_blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
