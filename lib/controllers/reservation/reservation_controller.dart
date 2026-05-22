import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/apartment_model.dart';

class ReservationController extends GetxController {

  final ApartmentModel apartment;

  ReservationController({
    required this.apartment,
  });

  /// selected dates
  final Rxn<DateTime> startDate =
  Rxn<DateTime>();

  final Rxn<DateTime> endDate =
  Rxn<DateTime>();

  /// loading
  final RxBool isLoading =
      false.obs;

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
              primary: Color(0xFFC8A96B),
            ),
          ),

          child: child!,
        );
      },
    );

    if (picked != null) {

      startDate.value =
          picked.start;

      endDate.value =
          picked.end;
    }
  }

  /// nights
  int get nights {

    if (startDate.value == null ||
        endDate.value == null) {
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

  /// validation
  bool validateDates() {

    if (startDate.value == null ||
        endDate.value == null) {

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
}