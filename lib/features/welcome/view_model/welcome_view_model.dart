import 'package:flutter/material.dart';

class WelcomeViewModel {
  static final image = Image.asset(
    'assets/image.png',
    width: 225,
    height: 175,
    fit: BoxFit.cover,
  );

  static const String welcomeMessage =
      'مرحبًا بكم في تطبيق الجمعية الخيرية للقرآن الكريم';

  static const String subMessage =
      'تعلم القرآن الكريم وانشر الخير بين الناس، انضم إلينا وابدأ رحلتك مع كتاب الله';

  static const String ayah = '﴿وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا﴾';
}
