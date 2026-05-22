import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../notifications/notification_page.dart';
import '../../controllers/auth/auth_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../services/auth_service.dart';

import '../auth/login_page.dart';

class ProfilePage
    extends StatefulWidget {

  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  final authController =
  Get.find<AuthController>();

  String name = '';
  String phone = '';
  String role = '';

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadUser();
  }

  /// load user
  Future<void> loadUser() async {

    final loadedName =
    await AuthService.getName();

    final loadedPhone =
    await AuthService.getPhone();

    final loadedRole =
    await AuthService.getRole();

    if (!mounted) {
      return;
    }

    setState(() {

      name =
          loadedName ?? '';

      phone =
          loadedPhone ?? '';

      role =
          loadedRole ?? '';

      isLoading = false;
    });
  }

  /// logout
  Future<void> logout() async {

    await authController
        .logout();

    Get.offAll(
          () => const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(

        title: const Text(
          'Profile',
        ),
      ),

      body: isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : SingleChildScrollView(

        padding:
        const EdgeInsets.all(
          AppSpacing.screen,
        ),

        child: Column(

          children: [

            /// avatar
            Container(

              width: 110,
              height: 110,

              decoration:
              BoxDecoration(

                color:
                AppColors.primary,

                borderRadius:
                BorderRadius.circular(
                  30,
                ),
              ),

              child: const Icon(

                Icons.person,

                size: 60,

                color:
                Colors.white,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            /// name
            Text(

              name,

              style:
              AppTextStyles.h1,
            ),

            const SizedBox(
              height: 8,
            ),

            /// phone
            Text(

              phone,

              style:
              AppTextStyles.body,
            ),

            const SizedBox(
              height: 12,
            ),

            /// role badge
            Container(

              padding:
              const EdgeInsets.symmetric(

                horizontal: 18,
                vertical: 8,
              ),

              decoration:
              BoxDecoration(

                color:
                AppColors.primary
                    .withValues(
                  alpha: .15,
                ),

                borderRadius:
                BorderRadius.circular(
                  100,
                ),
              ),

              child: Text(

                role,

                style: const TextStyle(

                  fontWeight:
                  FontWeight.bold,

                  color:
                  AppColors.primaryDark,
                ),
              ),
            ),

            const SizedBox(
              height: 36,
            ),

            /// settings section
            _ProfileTile(

              icon:
              Icons.favorite_border,

              title:
              'Favorites',

              subtitle:
              'Saved apartments',

              onTap: () {},
            ),

            _ProfileTile(

              icon:
              Icons.calendar_month,

              title:
              'Reservations',

              subtitle:
              'Your booking history',

              onTap: () {

                Get.to(
                      () =>
                  const NotificationPage(),
                );
              },
            ),

            _ProfileTile(

              icon:
              Icons.notifications_none,

              title:
              'Notifications',

              subtitle:
              'Latest updates',

              onTap: () {},
            ),

            _ProfileTile(

              icon:
              Icons.settings_outlined,

              title:
              'Settings',

              subtitle:
              'App preferences',

              onTap: () {},
            ),

            const SizedBox(
              height: 40,
            ),

            /// logout button
            SizedBox(

              width:
              double.infinity,

              height: 58,

              child: ElevatedButton.icon(

                onPressed:
                logout,

                icon: const Icon(
                  Icons.logout,
                ),

                label: const Text(
                  'Logout',
                ),

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile
    extends StatelessWidget {

  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const _ProfileTile({

    required this.icon,

    required this.title,

    required this.subtitle,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 14,
      ),

      child: Material(

        color:
        AppColors.surface,

        borderRadius:
        BorderRadius.circular(
          22,
        ),

        child: InkWell(

          borderRadius:
          BorderRadius.circular(
            22,
          ),

          onTap: onTap,

          child: Padding(

            padding:
            const EdgeInsets.all(
              18,
            ),

            child: Row(

              children: [

                Container(

                  width: 52,
                  height: 52,

                  decoration:
                  BoxDecoration(

                    color:
                    AppColors.primary
                        .withValues(
                      alpha: .12,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),
                  ),

                  child: Icon(

                    icon,

                    color:
                    AppColors.primary,
                  ),
                ),

                const SizedBox(
                  width: 16,
                ),

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(

                        title,

                        style:
                        const TextStyle(

                          fontWeight:
                          FontWeight.bold,

                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(

                        subtitle,

                        style:
                        AppTextStyles.muted,
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}