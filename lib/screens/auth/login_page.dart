import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/owner/owner_home_page.dart';
import '../home/home_page.dart';
import 'register_choose_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey          = GlobalKey<FormState>();
  final phoneController  = TextEditingController();
  final passController   = TextEditingController();
  final authController   = Get.find<AuthController>();
  bool _obscure = true;

  @override
  void dispose() {
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    final success = await authController.login(
      phone: phoneController.text.trim(),
      password: passController.text.trim(),
    );
    if (!mounted) return;
    if (!success) {
      Get.snackbar('Erreur', 'login_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (authController.role.value == AppConstants.ownerRole) {
      Get.offAll(() => const OwnerHomePage());
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a1a1a),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.apartment,
                          color: Color(0xFFC9A86A),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SAKAN',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1a1a1a),
                              letterSpacing: 0.06,
                            ),
                          ),
                          Text(
                            'login_subtitle'.tr,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// Phone
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 15),
                    decoration: _inputDeco(
                      hint: 'phone'.tr,
                      icon: Icons.phone_outlined,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'phone_required'.tr;
                      if (v.length != 8) return 'phone_invalid'.tr;
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  /// Password
                  TextFormField(
                    controller: passController,
                    obscureText: _obscure,
                    style: const TextStyle(fontSize: 15),
                    decoration: _inputDeco(
                      hint: 'password'.tr,
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'password_required'.tr;
                      if (v.length < 6) return 'password_min'.tr;
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// Login button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed:
                      authController.isLoading.value ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a1a1a),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        authController.isLoading.value
                            ? 'loading'.tr
                            : 'login_btn'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),

                  const SizedBox(height: 20),

                  /// Divider
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: Color(0xFFE9E4DA))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('ou',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ),
                      const Expanded(
                          child: Divider(color: Color(0xFFE9E4DA))),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Register
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () =>
                          Get.to(() => const RegisterChoosePage()),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEAE5DB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'no_account'.tr,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'create_account'.tr,
                            style: const TextStyle(
                              color: Color(0xFFC9A86A),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      prefixIcon: Icon(icon, color: const Color(0xFFC9A86A), size: 22),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEAE5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEAE5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC9A86A), width: 1.5),
      ),
    );
  }
}