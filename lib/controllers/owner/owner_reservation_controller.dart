import 'package:get/get.dart';

import '../../models/owner_reservation_model.dart';

import '../../services/owner_reservation_service.dart';

class OwnerReservationController
    extends GetxController {

  final reservations =
      <OwnerReservationModel>[].obs;

  final isLoading =
      false.obs;

  @override
  void onInit() {

    super.onInit();

    loadReservations();
  }

  Future<void> loadReservations()
  async {

    try {

      isLoading.value = true;

      final result =
      await OwnerReservationService
          .getReservations();

      reservations.assignAll(
        result,
      );

    } finally {

      isLoading.value = false;
    }
  }
}