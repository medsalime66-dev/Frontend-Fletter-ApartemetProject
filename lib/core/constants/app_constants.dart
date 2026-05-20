class AppConstants{

  AppConstants._();

  ///app
  static const String appName='Sakan';

  ///storage
  static const String tokenKey='token';
  static const String roleKey='role';
  static const String userIdKey='userId';
  static const String nameKey='name';
  static const String phoneKey='phone';

  ///roles
  static const String ownerRole='OWNER';
  static const String workerRole='WORKER';

  ///status
  static const String approved='APPROVED';
  static const String pending='PENDING';
  static const String rejected='REJECTED';

  ///timeouts
  static const int connectTimeout=10;
  static const int receiveTimeout=10;

  ///pagination
  static const int pageSize=10;
}