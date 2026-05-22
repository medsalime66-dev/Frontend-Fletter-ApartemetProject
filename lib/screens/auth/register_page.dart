import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/primary_button.dart';

import '../home/home_page.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final formKey =
  GlobalKey<FormState>();

  final nameController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final authController =
  Get.find<AuthController>();

  @override
  void dispose() {

    nameController.dispose();

    phoneController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  /// register
  Future<void> register() async {

    if (!formKey.currentState!
        .validate()) {

      return;
    }

    final success =
    await authController.register(

      name:
      nameController.text.trim(),

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

        'Register failed',

        snackPosition:
        SnackPosition.BOTTOM,
      );

      return;
    }

    Get.offAll(
          () => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset: true,

      appBar: AppBar(),

      body: SafeArea(

        child: SingleChildScrollView(

          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,

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

                const SizedBox(height: 10),

                const Text(

                  'Créer un compte',

                  style:
                  AppTextStyles.h1,
                ),

                const SizedBox(height: 8),

                const Text(

                  'Créez votre compte pour continuer.',

                  style:
                  AppTextStyles.muted,
                ),

                const SizedBox(height: 30),

                AppTextField(

                  label:
                  'Nom complet',

                  icon:
                  Icons.person_outline,

                  controller:
                  nameController,
                ),

                const SizedBox(height: 14),

                AppTextField(

                  label:
                  'Numéro de téléphone',

                  icon:
                  Icons.phone_outlined,

                  isPhone: true,

                  controller:
                  phoneController,
                ),

                const SizedBox(height: 14),

                AppTextField(

                  label:
                  'Mot de passe',

                  icon:
                  Icons.lock_outline,

                  isPassword: true,

                  controller:
                  passwordController,
                ),

                const SizedBox(height: 30),

                Obx(() {

                  return PrimaryButton(

                    text:
                    authController
                        .isLoading
                        .value

                        ? 'Chargement...'

                        : 'Créer',

                    onPressed:
                    authController
                        .isLoading
                        .value

                        ? null

                        : register,
                  );
                }),

                SizedBox(

                  height:
                  MediaQuery.of(context)
                      .viewInsets
                      .bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}