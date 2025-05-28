import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:abhrna/routes/app_routes.dart';
import 'package:abhrna/routes/app_router.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/translations/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:abhrna/providers/providers.dart';
import 'package:abhrna/themes/theme.dart';

void main() async {
  // تهيئة Flutter قبل تشغيل أي كود غير متزامن
  WidgetsFlutterBinding.ensureInitialized();

  // إجبار اتجاه الشاشة على الوضع العمودي فقط
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // تهيئة مكتبة الترجمة EasyLocalization
  await EasyLocalization.ensureInitialized();

  // تشغيل التطبيق داخل EasyLocalization و MultiProvider
  runApp(
    EasyLocalization(
      startLocale: const Locale('ar'), // اللغة الافتراضية عند التشغيل
      supportedLocales: const [Locale('ar'), Locale('en')], // اللغات المدعومة
      fallbackLocale: const Locale('ar'), // لغة الطوارئ عند الخطأ
      path: 'assets/translations', // مسار ملفات الترجمة
      assetLoader: const CodegenLoader(), // تحميل المفاتيح المولدة
      child: MultiProvider(
        providers: appProviders, // مزودي الحالة (من ملف providers.dart)
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LocaleKeys.abhrna.tr(),
      debugShowCheckedModeBanner: false,

      // إعدادات الترجمة حسب السياق الحالي
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // الثيم الداكن والفاتح
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,

      // المسار الابتدائي
      initialRoute: AppRoutes.splashScreen,

      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
