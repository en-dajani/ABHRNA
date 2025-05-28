import 'package:abhrna/screens/boat_form_screen.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// الشاشات المستخدمة
import 'package:abhrna/screens/splash_screen.dart';
import 'package:abhrna/screens/welcome_screen.dart';
import 'package:abhrna/screens/register_screen.dart';
import 'package:abhrna/screens/login_screen.dart';
import 'package:abhrna/screens/home_screen.dart';

import 'app_routes.dart';

/// كلاس مسؤول عن إدارة التنقلات داخل التطبيق
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // شاشة البداية (splash)
      case AppRoutes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // شاشة الترحيب
      case AppRoutes.welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      // شاشة إنشاء حساب جديد
      case AppRoutes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      // شاشة تسجيل الدخول
      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      // الشاشة الرئيسية بعد الدخول
      case AppRoutes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // شاشة اضافة او تعديل القارب
      case AppRoutes.boatFormScreen:
        return MaterialPageRoute(builder: (_) => const BoatFormScreen());

      // أي مسار غير معروف يفتح شاشة خطأ
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('error').tr()),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 200),
                  SizedBox(height: 16),
                  Text(LocaleKeys.not_found_404.tr()),
                ],
              ),
            ),
          ),
        );
    }
  }
}
