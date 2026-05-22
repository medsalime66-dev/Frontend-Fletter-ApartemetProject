import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';

import '../../controllers/apartment/apartment_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../screens/owner/create_apartment_page.dart';

import '../../widgets/apartment/apartment_card.dart';

import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_skeleton.dart';

import '../../screens/auth/login_page.dart';

import '../../screens/detail/detail_page.dart';

import '../../screens/owner/owner_notifications_page.dart';

import '../../screens/owner/owner_reservations_page.dart';

class OwnerHomePage
    extends StatefulWidget {

  const OwnerHomePage({
    super.key,
  });

  @override
  State<OwnerHomePage> createState() =>
      _OwnerHomePageState();
}

class _OwnerHomePageState
    extends State<OwnerHomePage> {

  final authController =
  Get.find<AuthController>();

  final apartmentController =
  Get.find<ApartmentController>();

  @override
  void initState() {

    super.initState();

    apartmentController
        .loadOwnerApartments();
  }

  /// logout
  Future<void> logout() async {

    await authController.logout();

    Get.offAll(
          () => const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() {

      final apartments =
          apartmentController
              .ownerApartments;

      final isLoading =
          apartmentController
              .isLoading
              .value;

      return Scaffold(

        appBar: AppBar(

          title: const Text(
            'Owner Dashboard',
          ),

          actions: [

            IconButton(

              onPressed: () {

                Get.to(
                      () =>
                  const OwnerReservationsPage(),
                );
              },

              icon: const Icon(
                Icons.calendar_month,
              ),
            ),

            IconButton(

              onPressed: () {

                Get.to(
                      () =>
                  const OwnerNotificationsPage(),
                );
              },

              icon: const Icon(
                Icons.notifications_none,
              ),
            ),

            IconButton(

              onPressed: logout,

              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),

        body: isLoading

            ? const LoadingSkeleton()

            : apartments.isEmpty

            ? const EmptyState(
          text:
          'No apartments found',
        )

            : RefreshIndicator(

          onRefresh: () async {

            await apartmentController
                .loadOwnerApartments();
          },

          child: ListView(

            padding:
            const EdgeInsets.all(
              AppSpacing.screen,
            ),

            children: [

              const Text(

                'My Apartments',

                style:
                AppTextStyles.h1,
              ),

              const SizedBox(
                height: 24,
              ),

              ...apartments.map(
                    (apartment) {

                  return ApartmentCard(

                    apartment:
                    apartment,

                    onTap: () {

                      Get.to(
                            () => DetailPage(
                          apartment:
                          apartment,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),

        floatingActionButton:
        FloatingActionButton.extended(

          backgroundColor:
          AppColors.primary,

          onPressed: () async {

            await Get.to(
                  () =>
              const CreateApartmentPage(),
            );

            apartmentController
                .loadOwnerApartments();
          },

          icon: const Icon(
            Icons.add,
          ),

          label: const Text(
            'Add Apartment',
          ),
        ),
      );
    });
  }
}