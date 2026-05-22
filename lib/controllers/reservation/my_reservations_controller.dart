import 'package:get/get.dart';

import '../../models/reservation_model.dart';

import '../../services/reservation_service.dart';

class MyReservationsController
    extends GetxController {

  final reservations =
      <Reservation>[].obs;

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

      final data =
      await ReservationService
          .getMyReservations();

      reservations.value = data;

    } finally {

      isLoading.value = false;
    }
  }
}