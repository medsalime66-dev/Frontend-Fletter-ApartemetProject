import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';

import '../auth/login_page.dart';

import '../home/home_page.dart';

import '../../widgets/owner/owner_home_page.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage> {

  final authController =
  Get.find<AuthController>();

  @override
  void initState() {

    super.initState();

    checkLogin();
  }

  /// check authentication
  Future<void> checkLogin() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    await authController.initAuth();

    if (!mounted) {
      return;
    }

    /// not logged in
    if (!authController.isLoggedIn.value) {

      Get.off(
            () => const LoginPage(),
      );

      return;
    }

    /// owner
    if (authController.role.value ==
        'OWNER') {

      Get.off(
            () => const OwnerHomePage(),
      );

      return;
    }

    /// user
    Get.off(
          () => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Container(

              height: 110,

              width: 110,

              decoration: BoxDecoration(

                color: Colors.black,

                borderRadius:
                BorderRadius.circular(30),
              ),

              child: const Icon(

                Icons.apartment,

                size: 55,

                color: Colors.amber,
              ),
            ),

            const SizedBox(height: 24),

            const Text(

              'SAKAN',

              style: TextStyle(

                fontSize: 32,

                fontWeight:
                FontWeight.w900,
              ),
            ),

            const SizedBox(height: 18),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}