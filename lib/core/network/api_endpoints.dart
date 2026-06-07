import '../config/app_config.dart';

class ApiEndpoints {

  ApiEndpoints._();

  /// base url — مأخوذ من AppConfig لتجنب التكرار
  static String get baseUrl => AppConfig.baseUrl;

  /// auth
  static const String login =
      '/auth/login';

  static const String register =
      '/auth/register';

  /// apartments
  static const String apartments =
      '/apartments';

  /// reservations
  static const String reservations =
      '/reservations';

  /// payments
  static const String payments =
      '/payments';

  /// notifications
  static const String notifications =
      '/notifications';
}