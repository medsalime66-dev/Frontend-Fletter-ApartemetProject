class AppConfig {

  AppConfig._();

  /// ⚠ غيّر الـ IP هنا فقط — كل الملفات تقرأ منه
  /// للتطوير المحلي: استخدم IP الخاص بجهازك
  /// للإنتاج: ضع رابط السيرفر الحقيقي
  static const String baseUrl =
      'https://backend-fletter-apartemetproject-production.up.railway.app/api';

  static String get serverUrl {
    return baseUrl.replaceAll('/api', '');
  }
}