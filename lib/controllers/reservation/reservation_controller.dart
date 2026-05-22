import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/apartment_model.dart';

import '../../services/reservation_service.dart';

class ReservationController
    extends GetxController {

  final ApartmentModel apartment;

  ReservationController({
    required this.apartment,
  });

  /// unavailable dates
  final unavailableDates =
      <DateTime>[].obs;

  /// dates
  final Rxn<DateTime> startDate =
  Rxn<DateTime>();

  final Rxn<DateTime> endDate =
  Rxn<DateTime>();

  /// loading
  final RxBool isLoading =
      false.obs;

  /// reservation success
  final RxBool reservationSuccess =
      false.obs;

  @override
  void onInit() {

    super.onInit();

    loadUnavailableDates();
  }

  /// load unavailable dates
  Future<void> loadUnavailableDates()
  async {

    unavailableDates.value =
    await ReservationService
        .getUnavailableDates(
      apartment.id,
    );
  }

  /// check unavailable
  bool isDateUnavailable(
      DateTime date,
      ) {

    return unavailableDates.any(

          (d) =>

      d.year == date.year &&

          d.month == date.month &&

          d.day == date.day,
    );
  }

  /// pick dates
  Future<void> pickDateRange(
      BuildContext context,
      ) async {

    final picked =
    await showDateRangePicker(

      context: context,

      firstDate: DateTime.now(),

      lastDate: DateTime(2030),

      builder: (context, child) {

        return Theme(

          data:
          Theme.of(context).copyWith(

            colorScheme:
            const ColorScheme.light(

              primary:
              Color(0xFFC8A96B),
            ),
          ),

          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    /// validate unavailable dates
    DateTime current =
        picked.start;

    bool invalid = false;

    while (
    !current.isAfter(
      picked.end,
    )
    ) {

      if (
      isDateUnavailable(
        current,
      )
      ) {

        invalid = true;

        break;
      }

      current =
          current.add(
            const Duration(
              days: 1,
            ),
          );
    }

    if (invalid) {

      Get.snackbar(

        'Unavailable Dates',

        'Some selected dates are already reserved',

        snackPosition:
        SnackPosition.BOTTOM,
      );

      return;
    }

    startDate.value =
        picked.start;

    endDate.value =
        picked.end;
  }

  /// nights
  int get nights {

    if (
    startDate.value == null ||

        endDate.value == null
    ) {

      return 0;
    }

    return endDate.value!
        .difference(
      startDate.value!,
    )
        .inDays;
  }

  /// total
  double get total {

    return nights *
        apartment.pricePerNight;
  }

  /// validate
  bool validateDates() {

    if (
    startDate.value == null ||

        endDate.value == null
    ) {

      Get.snackbar(

        'Error',

        'Please select reservation dates',

        snackPosition:
        SnackPosition.BOTTOM,
      );

      return false;
    }

    return true;
  }

  /// create reservation
  Future<bool> createReservation()
  async {

    try {

      if (
      startDate.value == null ||

          endDate.value == null
      ) {

        Get.snackbar(

          'Error',

          'Please select dates',

          snackPosition:
          SnackPosition.BOTTOM,
        );

        return false;
      }

      isLoading.value = true;

      final success =
      await ReservationService
          .createReservation(

        apartmentId:
        apartment.id,

        startDate:
        startDate.value!
            .toIso8601String()
            .split('T')[0],

        endDate:
        endDate.value!
            .toIso8601String()
            .split('T')[0],
      );

      reservationSuccess.value =
          success;

      if (!success) {

        Get.snackbar(

          'Reservation Failed',

          'Selected dates unavailable',

          snackPosition:
          SnackPosition.BOTTOM,
        );
      }

      return success;

    } catch (e) {

      Get.snackbar(

        'Reservation Error',

        'Something went wrong',

        snackPosition:
        SnackPosition.BOTTOM,
      );

      return false;

    } finally {

      isLoading.value = false;
    }
  }
}