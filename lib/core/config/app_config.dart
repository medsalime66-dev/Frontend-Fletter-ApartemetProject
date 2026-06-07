class AppConfig {

  AppConfig._();

  /// ⚠ غيّر الـ IP هنا فقط — كل الملفات تقرأ منه
  /// للتطوير المحلي: استخدم IP الخاص بجهازك
  /// للإنتاج: ضع رابط السيرفر الحقيقي
  static const String baseUrl =
      'http://192.168.100.41:8080/api';

  static String get serverUrl {
    return baseUrl.replaceAll('/api', '');
  }
}