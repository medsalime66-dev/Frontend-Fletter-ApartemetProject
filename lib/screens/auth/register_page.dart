import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final formKey        = GlobalKey<FormState>();
  final nameCtrl       = TextEditingController();
  final phoneCtrl      = TextEditingController();
  final passCtrl       = TextEditingController();
  final authController = Get.find<AuthController>();
  bool _obscure = true;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    final success = await authController.register(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      Get.snackbar('Compte créé', 'Connectez-vous maintenant',
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => const LoginPage());
    } else {
      Get.snackbar('Erreur', 'register_failed'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFA),
      body: Column(
        children: [

          /// Dark header
          Container(
            color: const Color(0xFF1a1a1a),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 14,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back_ios_new,
                          size: 18, color: Color(0xFF666666)),
                      SizedBox(width: 6),
                      Text('Retour',
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF666666))),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Compte client',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Remplissez vos informations',
                  style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),

          /// Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  children: [

                    const SizedBox(height: 8),

                    /// Name
                    TextFormField(
                      controller: nameCtrl,
                      style: const TextStyle(fontSize: 15),
                      decoration: _inputDeco(
                        hint: 'full_name'.tr,
                        icon: Icons.person_outline,
                      ),
                      validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Ce champ est requis'
                          : null,
                    ),

                    const SizedBox(height: 14),

                    /// Phone
                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 15),
                      decoration: _inputDeco(
                        hint: 'phone_number'.tr,
                        icon: Icons.phone_outlined,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'phone_required'.tr;
                        if (v.length != 8) return 'phone_invalid'.tr;
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    /// Password
                    TextFormField(
                      controller: passCtrl,
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
                            size: 22,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'password_required'.tr;
                        if (v.length < 6) return 'password_min'.tr;
                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    /// Submit
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC9A86A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          authController.isLoading.value
                              ? 'loading'.tr
                              : 'create'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () =>
                          Get.offAll(() => const LoginPage()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Déjà un compte ? ',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            'login_btn'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFC9A86A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
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
        borderSide:
        const BorderSide(color: Color(0xFFC9A86A), width: 1.5),
      ),
    );
  }
}