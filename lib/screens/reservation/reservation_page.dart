import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controllers/reservation/reservation_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../widgets/reservation/reservation_summary.dart';
import '../../widgets/reservation/date_status_legend.dart';

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
              height: 24,
            ),

            /// legend
            const DateStatusLegend(),

            const SizedBox(
              height: 20,
            ),

            /// calendar
            Obx(() {

              return Container(

                padding:
                const EdgeInsets.all(
                  16,
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

                child: TableCalendar(

                  firstDay:
                  DateTime.now(),

                  lastDay:
                  DateTime(2030),

                  focusedDay:
                  controller
                      .startDate
                      .value ??
                      DateTime.now(),

                  rangeStartDay:
                  controller
                      .startDate
                      .value,

                  rangeEndDay:
                  controller
                      .endDate
                      .value,

                  rangeSelectionMode:
                  RangeSelectionMode
                      .toggledOn,

                  availableGestures:
                  AvailableGestures.all,

                  onRangeSelected:
                      (
                      start,
                      end,
                      focusedDay,
                      ) {

                    if (
                    start == null ||
                        end == null
                    ) {

                      return;
                    }

                    DateTime current =
                        start;

                    bool blocked =
                    false;

                    while (
                    !current.isAfter(
                      end,
                    )
                    ) {

                      if (
                      controller
                          .isDateUnavailable(
                        current,
                      )
                      ) {

                        blocked =
                        true;

                        break;
                      }

                      current =
                          current.add(

                            const Duration(
                              days: 1,
                            ),
                          );
                    }

                    if (blocked) {

                      Get.snackbar(

                        'Unavailable',

                        'Some selected dates are reserved',

                        snackPosition:
                        SnackPosition
                            .BOTTOM,
                      );

                      return;
                    }

                    controller
                        .startDate
                        .value = start;

                    controller
                        .endDate
                        .value = end;
                  },

                  calendarBuilders:
                  CalendarBuilders(

                    /// unavailable
                    defaultBuilder:
                        (
                        context,
                        day,
                        focusedDay,
                        ) {

                      final unavailable =
                      controller
                          .isDateUnavailable(
                        day,
                      );

                      if (
                      !unavailable
                      ) {

                        return null;
                      }

                      return Container(

                        margin:
                        const EdgeInsets
                            .all(6),

                        decoration:
                        const BoxDecoration(

                          color:
                          Colors.red,

                          shape:
                          BoxShape.circle,
                        ),

                        alignment:
                        Alignment.center,

                        child: Text(

                          '${day.day}',

                          style:
                          const TextStyle(

                            color:
                            Colors.white,
                          ),
                        ),
                      );
                    },

                    /// today
                    todayBuilder:
                        (
                        context,
                        day,
                        focusedDay,
                        ) {

                      return Container(

                        margin:
                        const EdgeInsets
                            .all(6),

                        decoration:
                        const BoxDecoration(

                          color:
                          AppColors
                              .primary,

                          shape:
                          BoxShape.circle,
                        ),

                        alignment:
                        Alignment.center,

                        child: Text(

                          '${day.day}',

                          style:
                          const TextStyle(

                            color:
                            Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),

            const SizedBox(
              height: 28,
            ),

            /// selected dates
            Obx(() {

              return Container(

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

            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}