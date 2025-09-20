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
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const RegistrationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // نحصل على ارتفاع الشاشة لنقسمها بشكل نسبي
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.light_blue,
      body: SingleChildScrollView(
        child: SizedBox(
          // نعطي العمود الرئيسي ارتفاع الشاشة بالكامل
          height: screenHeight,
          child: Column(
            children: [
              // --- الجزء العلوي: الشعار والخلفية ---
              // لا نستخدم Expanded، بل نعطيه نسبة من ارتفاع الشاشة
              Container(
                height: screenHeight * 0.45, // يأخذ 45% من الشاشة
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.dark_teal_blue, AppColors.teal_blue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
                child: Center(
                  child: Hero( // استخدام Hero لحركة انتقال جميلة للشعار
                    tag: "logo_info",
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.ivory_yellow,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: WelcomeViewModel.image,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // --- الجزء السفلي: النصوص والأزرار ---
              // لا نستخدم Expanded، بل نلف المحتوى بـ Expanded لملء المساحة المتبقية
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                            style: GoogleFonts.cairo(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark_teal_blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            WelcomeViewModel.subMessage,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: AppColors.steel_blue,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(flex: 3),

                          // زر الدخول
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal_blue2,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            onPressed: () => _navigateToLogin(context),
                            child: Text(
                              'الدخول',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // زر التسجيل
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.teal_blue2,
                              side: const BorderSide(color: AppColors.teal_blue2, width: 2),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () => _navigateToRegister(context),
                            child: Text(
                              'إنشاء حساب',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(flex: 2),
                          Text(
                            WelcomeViewModel.ayah,
                            style: GoogleFonts.amiri(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.night_blue.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
