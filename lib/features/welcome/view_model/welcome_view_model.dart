// In lib/features/welcome/view_model/welcome_view_model.dart

import 'package:flutter/material.dart';

class WelcomeViewModel {
  static final image = Image.asset(
    'assets/image111.png',
    width: 100,
    height: 100,
    fit: BoxFit.cover,
  );

  static const String welcomeMessage = 'مرحباً بك في بيئة الإيمان الرقمية';
  static const String subMessage = 'انضم إلى مجتمعنا القرآني، حيث يلتقي العلم بالنور، وتتلى الآيات بقلوب خاشعة.';
  static const String returningUserMessage = 'أهلاً بعودتك!'; // <-- رسالة جديدة
  static const String ayah = '﴿ وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا ﴾';
}
