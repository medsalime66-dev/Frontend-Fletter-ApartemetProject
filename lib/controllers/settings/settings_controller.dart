import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {

  final notificationsEnabled = true.obs;
  final language = 'fr'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled.value = prefs.getBool('notifications') ?? true;
    language.value = prefs.getString('language') ?? 'fr';
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
  }

  Future<void> setLanguage(String lang) async {

    language.value = lang;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);

    /// تغيير اللغة فوراً
    final country = lang == 'fr' ? 'FR' : 'AR';
    Get.updateLocale(Locale(lang, country));
  }
}