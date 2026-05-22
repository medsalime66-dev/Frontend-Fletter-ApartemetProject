import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';

import '../../core/constants/app_constants.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/primary_button.dart';

import '../home/home_page.dart';

import '../../widgets/owner/owner_home_page.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  final formKey =
  GlobalKey<FormState>();

  final phoneController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final authController =
  Get.find<AuthController>();

  @override
  void dispose() {

    phoneController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  /// login
  Future<void> login() async {

    if (!formKey.currentState!
        .validate()) {

      return;
    }

    final success =
    await authController.login(

      phone:
      phoneController.text.trim(),

      password:
      passwordController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (!success) {

      Get.snackbar(

        'Error',

        'Login failed',

        snackPosition:
        SnackPosition.BOTTOM,
      );

      return;
    }

    /// owner
    if (authController.role.value ==
        AppConstants.ownerRole) {

      Get.offAll(
            () => const OwnerHomePage(),
      );

      return;
    }

    /// user
    Get.offAll(
          () => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            padding:
            const EdgeInsets.all(
              AppSpacing.screen,
            ),

            child: Form(

              key: formKey,

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(

                    'Connexion',

                    style:
                    AppTextStyles.h1,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  const Text(

                    'Connectez-vous à votre compte',

                    style:
                    AppTextStyles.muted,
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  AppTextField(

                    controller:
                    phoneController,

                    label:
                    'Téléphone',

                    icon:
                    Icons.phone_outlined,

                    isPhone: true,

                    validator: (value) {

                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {

                        return 'Téléphone requis';
                      }

                      if (value.length != 8) {

                        return 'Numéro invalide';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  AppTextField(

                    controller:
                    passwordController,

                    label:
                    'Mot de passe',

                    icon:
                    Icons.lock_outline,

                    isPassword: true,

                    validator: (value) {

                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {

                        return 'Mot de passe requis';
                      }

                      if (value.length < 6) {

                        return 'Minimum 6 caractères';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  Obx(() {

                    return PrimaryButton(

                      text:
                      authController
                          .isLoading
                          .value

                          ? 'Chargement...'

                          : 'Se connecter',

                      onPressed:
                      authController
                          .isLoading
                          .value

                          ? null

                          : login,
                    );
                  }),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      const Text(
                        'Pas de compte ?',
                      ),

                      TextButton(

                        onPressed: () {

                          Get.to(
                                () =>
                            const RegisterPage(),
                          );
                        },

                        child: const Text(
                          'Créer un compte',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}