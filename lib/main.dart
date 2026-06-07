import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/bindings/initial_binding.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/translations/app_translations.dart';
import 'screens/auth/splash_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();

  final prefs = await SharedPreferences.getInstance();
  final lang = prefs.getString('language') ?? 'fr';
  final country = lang == 'fr' ? 'FR' : 'AR';

  runApp(SakanApp(locale: Locale(lang, country)));
}

class SakanApp extends StatelessWidget {

  final Locale locale;
  const SakanApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(

      title: 'SAKAN',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: AppTheme.light,

      /// الترجمة
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('fr', 'FR'),

      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('ar', 'AR'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// نثبت LTR دائماً
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: child!,
        );
      },

      home: const SplashPage(),
    );
  }
}
