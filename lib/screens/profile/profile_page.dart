import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_page.dart';
import '../favorites/favorites_page.dart';
import '../notifications/notification_page.dart';
import '../reservation/my_reservations_page.dart';
import '../settings/settings_page.dart';

class ProfilePage extends StatelessWidget {

  const ProfilePage({super.key});

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => const LoginPage());
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'user'.tr;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String>(
      future: getUserName(),
      builder: (context, snapshot) {

        final userName = snapshot.data ?? 'user'.tr;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('profile'.tr, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(0xFFD4AF37),
                          child: const Icon(Icons.person, size: 45, color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          userName,
                          style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildTile(icon: Icons.favorite_border, titleKey: 'favorites', subtitleKey: 'saved_apartments',
                      onTap: () => Get.to(() => const FavoritesPage())),

                  _buildTile(icon: Icons.calendar_month, titleKey: 'my_reservations', subtitleKey: 'your_booking_history',
                      onTap: () => Get.to(() => const MyReservationsPage())),

                  _buildTile(icon: Icons.notifications_none, titleKey: 'notifications', subtitleKey: 'latest_updates',
                      onTap: () => Get.to(() => const NotificationPage())),

                  _buildTile(icon: Icons.settings_outlined, titleKey: 'settings', subtitleKey: 'app_settings',
                      onTap: () => Get.to(() => const SettingsPage())),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: logout,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.logout, color: Colors.red),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('logout'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                                const SizedBox(height: 4),
                                Text('disconnect'.tr, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTile({required IconData icon, required String titleKey, required String subtitleKey, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFFD4AF37)),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleKey.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitleKey.tr, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
