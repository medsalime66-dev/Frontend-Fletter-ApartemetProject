import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/owner/owner_reservation_controller.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_skeleton.dart';

import '../../widgets/owner/owner_reservation_tile.dart';

class OwnerReservationsPage
    extends StatelessWidget {

  const OwnerReservationsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final controller =
    Get.find<
        OwnerReservationController>();

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Reservations',
        ),
      ),

      body: Obx(() {

        if (
        controller
            .isLoading
            .value
        ) {

          return const LoadingSkeleton();
        }

        if (
        controller
            .reservations
            .isEmpty
        ) {

          return const EmptyState(

            text:
            'No reservations found',
          );
        }

        return RefreshIndicator(

          onRefresh:
          controller.loadReservations,

          child: ListView(

            padding:
            const EdgeInsets.all(
              AppSpacing.screen,
            ),

            children: [

              const Text(

                'Incoming Reservations',

                style:
                AppTextStyles.h1,
              ),

              const SizedBox(
                height: 24,
              ),

              ...controller
                  .reservations
                  .map((reservation) {

                return OwnerReservationTile(

                  apartment:
                  reservation
                      .apartmentTitle,

                  client:
                  reservation
                      .clientName,

                  status:
                  reservation.status,

                  startDate:
                  reservation.startDate,

                  endDate:
                  reservation.endDate,
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}