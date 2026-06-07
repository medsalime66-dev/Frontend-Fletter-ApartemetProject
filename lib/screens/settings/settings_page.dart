import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/settings/settings_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../auth/login_page.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

      _buildSection(title: 'account'.tr, children: [
        _buildInfoTile(icon: Icons.person_outline, title: 'name'.tr,
            trailing: FutureBuilder<String>(
              future: _getName(),
              builder: (_, snap) => Text(snap.data ?? '...', style: AppTextStyles.muted),
            )),
        _buildInfoTile(icon: Icons.phone_outlined, title: 'phone_label'.tr,
            trailing: FutureBuilder<String>(
              future: _getPhone(),
              builder: (_, snap) => Text(snap.data ?? '...', style: AppTextStyles.muted),
            )),
        _buildInfoTile(icon: Icons.badge_outlined, title: 'role'.tr,
            trailing: FutureBuilder<String>(
                future: _getRole(),
                builder: (_, snap) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(snap.data ?? '...', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 13)),
                )),
        )]),

        const SizedBox(height: 24),

        _buildSection(title: 'notifications'.tr, children: [
          Obx(() => _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'push_notifications'.tr,
            subtitle: 'receive_updates'.tr,
            value: controller.notificationsEnabled.value,
            onChanged: controller.toggleNotifications,
          )),
        ]),

        const SizedBox(height: 24),

        _buildSection(title: 'language'.tr, children: [
          Obx(() => _buildRadioTile(title: 'Français', value: 'fr', groupValue: controller.language.value,
              onChanged: (v) async {
                await controller.setLanguage(v!);
                Get.snackbar('Langue', 'fr_selected'.tr, snackPosition: SnackPosition.BOTTOM);
              })),
          Obx(() => _buildRadioTile(title: 'العربية', value: 'ar', groupValue: controller.language.value,
              onChanged: (v) async {
                await controller.setLanguage(v!);
                Get.snackbar('اللغة', 'ar_selected'.tr, snackPosition: SnackPosition.BOTTOM);
              })),
        ]),

        const SizedBox(height: 24),

        _buildSection(title: 'about'.tr, children: [
          _buildInfoTile(icon: Icons.info_outline, title: 'version'.tr, trailing: const Text('1.0.0', style: AppTextStyles.muted)),
          _buildInfoTile(icon: Icons.apartment, title: 'app'.tr, trailing: const Text('SAKAN', style: AppTextStyles.muted)),
        ]),

        const SizedBox(height: 24),

        GestureDetector(
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('logout'.tr),
                content: Text('logout_confirm'.tr),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('cancel'.tr)),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text('logout'.tr, style: const TextStyle(color: AppColors.danger)),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Get.offAll(() => const LoginPage());
            }
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.logout, color: AppColors.danger),
                ),
                const SizedBox(width: 16),
                Text('logout'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.danger)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 4, bottom: 10), child: Text(title, style: AppTextStyles.muted)),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile({required IconData icon, required String title, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 14),
        Text(title, style: AppTextStyles.body),
        const Spacer(),
        trailing,
      ]),
    );
  }

  Widget _buildSwitchTile({required IconData icon, required String title, required String subtitle, required bool value, required Function(bool) onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.body),
          Text(subtitle, style: AppTextStyles.muted),
        ])),
        Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
      ]),
    );
  }

  Widget _buildRadioTile({required String title, required String value, required String groupValue, required Function(String?) onChanged}) {
    return RadioListTile<String>(
      title: Text(title, style: AppTextStyles.body),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18),
    );
  }

  Future<String> _getName() async { final p = await SharedPreferences.getInstance(); return p.getString('name') ?? ''; }
  Future<String> _getPhone() async { final p = await SharedPreferences.getInstance(); return p.getString('phone') ?? ''; }
  Future<String> _getRole() async { final p = await SharedPreferences.getInstance(); return p.getString('role') ?? ''; }
}
