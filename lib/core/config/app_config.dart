class AppConfig {

  AppConfig._();

  static const String baseUrl =
      'http://192.168.100.41:8080/api';

  static String get serverUrl {

    return baseUrl
        .replaceAll('/api', '');
  }
}