import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../controllers/apartment/apartment_controller.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../controllers/owner/owner_reservation_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../screens/auth/login_page.dart';
import '../../screens/detail/detail_page.dart';
import '../../screens/notifications/notification_page.dart';
import '../../screens/owner/create_apartment_page.dart';
import '../../screens/owner/qr_scanner_page.dart';

import '../../widgets/apartment/apartment_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_skeleton.dart';
import '../../widgets/owner/owner_reservation_tile.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});

  @override
  State<OwnerHomePage> createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {

  int _currentIndex = 0;

  final authController       = Get.find<AuthController>();
  final apartmentController  = Get.find<ApartmentController>();
  final reservationController= Get.find<OwnerReservationController>();
  final notifController      = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    apartmentController.loadOwnerApartments();
    reservationController.loadReservations();
    notifController.loadNotifications();
  }

  // ===== AppBar ديناميكي حسب الـ tab =====
  String get _appBarTitle {
    switch (_currentIndex) {
      case 1:  return 'my_reservations'.tr;
      case 2:  return 'scan_qr'.tr;
      case 3:  return 'profile'.tr;
      default: return 'owner_dashboard'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        title: Text(_appBarTitle),

        automaticallyImplyLeading: false,

        /// جرس الإشعارات في الأعلى
        actions: [
          Obx(() {
            final unread = notifController.unreadCount;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => Get.to(() => const NotificationPage()),
                ),
                if (unread > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _ApartmentsTab(),
          _ReservationsTab(),
          _ScannerTab(),
          _ProfileTab(),
        ],
      ),

      /// 4 tabs فقط
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.apartment_outlined),
            selectedIcon: const Icon(Icons.apartment),
            label: 'owner_dashboard'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: 'my_reservations'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: const Icon(Icons.qr_code_scanner),
            label: 'scan_qr'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: 'profile'.tr,
          ),
        ],
      ),
    );
  }
}

/// ===== TAB 1: شققي =====
class _ApartmentsTab extends StatelessWidget {
  const _ApartmentsTab();

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<ApartmentController>();

    return Obx(() {

      final apartments = controller.ownerApartments;
      final isLoading  = controller.isLoading.value;

      return RefreshIndicator(

        onRefresh: controller.loadOwnerApartments,

        child: CustomScrollView(

          slivers: [

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('owner_dashboard'.tr, style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text(
                      '${apartments.length} ${'my_apartments'.tr}',
                      style: AppTextStyles.muted,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        _StatCard(
                          label: 'my_apartments'.tr,
                          value: '${apartments.length}',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Obx(() {
                          final count = Get.find<OwnerReservationController>()
                              .reservations.length;
                          return _StatCard(
                            label: 'my_reservations'.tr,
                            value: '$count',
                            color: AppColors.text,
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            if (isLoading)
              const SliverFillRemaining(child: LoadingSkeleton())

            else if (apartments.isEmpty)
              SliverFillRemaining(
                child: EmptyState(text: 'no_apartments_owner'.tr),
              )

            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) => ApartmentCard(
                      apartment: apartments[i],
                      onTap: () => Get.to(() => DetailPage(
                        apartment: apartments[i],
                        isOwner: true,
                      )),
                    ),
                    childCount: apartments.length,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

/// ===== TAB 2: الحجوزات =====
class _ReservationsTab extends StatelessWidget {
  const _ReservationsTab();

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<OwnerReservationController>();

    return Obx(() {

      if (controller.isLoading.value) return const LoadingSkeleton();

      return RefreshIndicator(
        onRefresh: controller.loadReservations,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            const SizedBox(height: 4),
            Text('incoming_reservations'.tr, style: AppTextStyles.h1),
            const SizedBox(height: 6),
            Text(
              '${controller.reservations.length} ${'my_reservations'.tr}',
              style: AppTextStyles.muted,
            ),
            const SizedBox(height: 24),
            if (controller.reservations.isEmpty)
              EmptyState(text: 'no_reservations'.tr)
            else
              ...controller.reservations.map((r) => OwnerReservationTile(
                apartment: r.apartmentTitle,
                client: r.clientName,
                status: r.status,
                startDate: r.startDate,
                endDate: r.endDate,
              )),
          ],
        ),
      );
    });
  }
}

/// ===== TAB 3: مسح QR =====
class _ScannerTab extends StatelessWidget {
  const _ScannerTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 4),
          Text('scan_qr'.tr, style: AppTextStyles.h1),
          const SizedBox(height: 8),
          Text('scan_frame'.tr, style: AppTextStyles.muted),
          const SizedBox(height: 40),

          Center(
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(24),
                color: AppColors.surface,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                size: 80,
                color: AppColors.border,
              ),
            ),
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => Get.to(() => const QrScannerPage()),
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              label: Text(
                'scan_qr'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== TAB 4: الملف الشخصي + تسجيل الخروج =====
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('logout'.tr),
        content: Text('logout_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'logout'.tr,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => const LoginPage());
    }
  }

  Future<String> _getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'Owner';
  }

  Future<String> _getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [

        const SizedBox(height: 8),

        /// Avatar + معلومات
        FutureBuilder<String>(
          future: _getName(),
          builder: (_, snap) => Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.person,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  snap.data ?? '...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<String>(
                  future: _getPhone(),
                  builder: (_, s) => Text(
                    s.data ?? '',
                    style: AppTextStyles.muted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'OWNER',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        /// إحصائيات
        Row(
          children: [
            Obx(() {
              final count = Get.find<ApartmentController>()
                  .ownerApartments.length;
              return _StatCard(
                label: 'my_apartments'.tr,
                value: '$count',
                color: AppColors.primary,
              );
            }),
            const SizedBox(width: 12),
            Obx(() {
              final count = Get.find<OwnerReservationController>()
                  .reservations.length;
              return _StatCard(
                label: 'my_reservations'.tr,
                value: '$count',
                color: AppColors.text,
              );
            }),
          ],
        ),

        const SizedBox(height: 28),

        /// زر تسجيل الخروج
        GestureDetector(
          onTap: () => _logout(context),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'logout'.tr,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.danger,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'disconnect'.tr,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }
}

/// ===== FAB — إضافة شقة =====
extension OwnerFAB on _ApartmentsTab {
  Widget buildFAB() {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.primary,
      onPressed: () async {
        await Get.to(() => const CreateApartmentPage());
        Get.find<ApartmentController>().loadOwnerApartments();
      },
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        'add_apartment'.tr,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// ===== Stat Card =====
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.muted),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}