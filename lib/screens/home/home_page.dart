import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/notification/notification_controller.dart';
import '../../controllers/apartment/apartment_controller.dart';
import '../notifications/notification_page.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/apartment/apartment_card.dart';
import '../../widgets/common/section_title.dart';
import '../detail/detail_page.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final apartmentController = Get.find<ApartmentController>();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    apartmentController.loadApartments();
  }

  @override
  Widget build(BuildContext context) {

    final pages = [
      const _HomeContent(),
      SearchPage(apartments: apartmentController.apartments),
      const ProfilePage(),
    ];

    return Obx(() => Scaffold(
      body: apartmentController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: .15),
        onDestinationSelected: (value) => setState(() => selectedIndex = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: 'home'.tr),
          NavigationDestination(icon: const Icon(Icons.search), selectedIcon: const Icon(Icons.search), label: 'search'.tr),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: 'profile'.tr),
        ],
      ),
    ));
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {

    final apartmentController = Get.find<ApartmentController>();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => await apartmentController.loadApartments(),
        child: Obx(() {
          final apartments = apartmentController.apartments;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [

              Row(
                children: [
                  Expanded(child: Text('SAKAN \n${'available_apartments'.tr}', style: AppTextStyles.h1)),
                  Obx(() {
                    final notifController = Get.find<NotificationController>();
                    final unread = notifController.notifications.where((n) => !n.isRead).length;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () => Get.to(() => const NotificationPage()),
                          icon: const Icon(Icons.notifications_none),
                        ),
                        if (unread > 0)
                          Positioned(
                            right: 6, top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              child: Text(unread.toString(), textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () => Get.to(() => SearchPage(apartments: apartments)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.muted),
                      const SizedBox(width: 10),
                      Text('search_hint'.tr, style: const TextStyle(color: AppColors.muted)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),

              SectionTitle(title: 'available_apartments'.tr, actionText: 'refresh'.tr),

              const SizedBox(height: 14),

              if (apartments.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(child: Text('no_apartments'.tr)),
                ),

              ...apartments.map((apartment) => ApartmentCard(
                apartment: apartment,
                onTap: () => Get.to(() => DetailPage(apartment: apartment)),
              )),
            ],
          );
        }),
      ),
    );
  }
}
