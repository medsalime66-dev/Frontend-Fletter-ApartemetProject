import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/reservation/reservation_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../widgets/reservation/reservation_summary.dart';

import '../payment/payment_page.dart';

class ReservationPage
    extends StatelessWidget {

  final ApartmentModel apartment;

  const ReservationPage({
    super.key,
    required this.apartment,
  });

  @override
  Widget build(BuildContext context) {

    final controller =
    Get.put(

      ReservationController(
        apartment: apartment,
      ),
    );

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Reservation',
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(
          AppSpacing.screen,
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// title
            Text(

              apartment.title,

              style:
              AppTextStyles.h1,
            ),

            const SizedBox(
              height: 12,
            ),

            /// location
            Row(

              children: [

                const Icon(

                  Icons.location_on,

                  size: 18,

                  color:
                  AppColors.primary,
                ),

                const SizedBox(
                  width: 6,
                ),

                Expanded(

                  child: Text(

                    "${apartment.city}, ${apartment.district}",

                    style:
                    AppTextStyles.muted,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 28,
            ),

            /// date picker
            Obx(() {

              return InkWell(

                onTap: () {

                  controller
                      .pickDateRange(
                    context,
                  );
                },

                borderRadius:
                BorderRadius.circular(
                  22,
                ),

                child: Container(

                  padding:
                  const EdgeInsets.all(
                    18,
                  ),

                  decoration:
                  BoxDecoration(

                    color:
                    AppColors.surface,

                    borderRadius:
                    BorderRadius.circular(
                      22,
                    ),

                    border:
                    Border.all(
                      color:
                      AppColors.border,
                    ),
                  ),

                  child: Row(

                    children: [

                      const Icon(
                        Icons.date_range,
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(

                        child: Text(

                          controller
                              .startDate
                              .value ==
                              null

                              ? 'Select reservation dates'

                              : '${controller.startDate.value.toString().split(' ')[0]} → ${controller.endDate.value.toString().split(' ')[0]}',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(
              height: 28,
            ),

            /// summary
            Obx(() {

              return ReservationSummary(

                nights:
                controller.nights,

                total:
                controller.total
                    .toInt(),
              );
            }),

            const SizedBox(
              height: 20,
            ),

            /// wallet
            Container(

              padding:
              const EdgeInsets.all(
                20,
              ),

              decoration:
              BoxDecoration(

                color:
                AppColors.surface,

                borderRadius:
                BorderRadius.circular(
                  24,
                ),

                border:
                Border.all(
                  color:
                  AppColors.border,
                ),
              ),

              child: Row(

                children: [

                  const Icon(
                    Icons.wallet,
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(

                    child: Text(
                      apartment.walletCode,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            /// continue payment
            SizedBox(

              width:
              double.infinity,

              height: 58,

              child: ElevatedButton(

                onPressed: () {

                  final valid =
                  controller
                      .validateDates();

                  if (!valid) {
                    return;
                  }

                  Get.to(

                        () => PaymentPage(

                      apartment:
                      apartment,

                      total:
                      controller
                          .total
                          .toInt(),

                      startDate:
                      controller
                          .startDate
                          .value!,

                      endDate:
                      controller
                          .endDate
                          .value!,
                    ),
                  );
                },

                child: const Text(
                  'Continue To Payment',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}