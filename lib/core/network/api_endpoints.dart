class ApiEndpoints{

  ApiEndpoints._();

  ///base url
  static const String baseUrl=
      'http://192.168.100.41:8080/api';

  ///auth
  static const String login=
      '/auth/login';

  static const String register=
      '/auth/register';

  ///apartments
  static const String apartments=
      '/apartments';

  static const String approvedApartments=
      '/apartments/approved';

  ///reservations
  static const String reservations=
      '/reservations';

  ///payments
  static const String payments=
      '/payments';

  ///notifications
  static const String notifications=
      '/notifications';
}