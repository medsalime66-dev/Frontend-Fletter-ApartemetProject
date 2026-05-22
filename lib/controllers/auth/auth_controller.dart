import 'package:get/get.dart';

import '../../services/auth_service.dart';

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

    role.value = userRole ?? '';

    isLoggedIn.value = true;
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
  }
}