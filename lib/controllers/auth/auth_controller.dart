import 'package:get/get.dart';

import '../../services/auth_service.dart';

import '../notification/notification_controller.dart';

import '../owner/owner_reservation_controller.dart';

class AuthController extends GetxController {

  final isLoading = false.obs;

  final role = ''.obs;

  final isLoggedIn = false.obs;

  /// initialize auth
  Future<void> initAuth() async {

    final token =
    await AuthService.getToken();

    if (token == null) {

      isLoggedIn.value = false;

      return;
    }

    final userRole =
    await AuthService.getRole();

    role.value =
        userRole ?? '';

    isLoggedIn.value = true;

    /// preload notifications
    await Get.find<
        NotificationController>()
        .loadNotifications();

    /// preload owner reservations
    await Get.find<
        OwnerReservationController>()
        .loadReservations();
  }

  /// login
  Future<bool> login({

    required String phone,

    required String password,

  }) async {

    try {

      isLoading.value = true;

      final success =
      await AuthService.login(

        phone: phone,

        password: password,
      );

      if (!success) {

        return false;
      }

      final userRole =
      await AuthService.getRole();

      role.value =
          userRole ?? '';

      isLoggedIn.value = true;

      /// load notifications
      await Get.find<
          NotificationController>()
          .loadNotifications();

      /// load owner reservations
      await Get.find<
          OwnerReservationController>()
          .loadReservations();

      return true;

    } catch (e) {

      return false;

    } finally {

      isLoading.value = false;
    }
  }

  /// register
  Future<bool> register({

    required String name,

    required String phone,

    required String password,

  }) async {

    try {

      isLoading.value = true;

      final success =
      await AuthService.register(

        name: name,

        phone: phone,

        password: password,
      );

      if (!success) {

        return false;
      }

      final loginSuccess =
      await AuthService.login(

        phone: phone,

        password: password,
      );

      if (!loginSuccess) {

        return false;
      }

      final userRole =
      await AuthService.getRole();

      role.value =
          userRole ?? '';

      isLoggedIn.value = true;

      /// load notifications
      await Get.find<
          NotificationController>()
          .loadNotifications();

      /// load owner reservations
      await Get.find<
          OwnerReservationController>()
          .loadReservations();

      return true;

    } catch (e) {

      return false;

    } finally {

      isLoading.value = false;
    }
  }

  /// logout
  Future<void> logout() async {

    await AuthService.logout();

    role.value = '';

    isLoggedIn.value = false;

    /// clear notifications
    Get.find<
        NotificationController>()
        .notifications
        .clear();

    /// clear reservations
    Get.find<
        OwnerReservationController>()
        .reservations
        .clear();
  }
}