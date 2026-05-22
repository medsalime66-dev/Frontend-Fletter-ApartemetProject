import 'package:get/get.dart';

import '../../models/apartment_model.dart';

import '../../repositories/apartment_repository.dart';

class ApartmentController
    extends GetxController {

  final repository =
  ApartmentRepository();

  final apartments =
      <ApartmentModel>[].obs;

  final ownerApartments =
      <ApartmentModel>[].obs;

  final isLoading =
      false.obs;

  /// load public apartments
  Future<void> loadApartments() async {

    try {

      isLoading.value = true;

      final result =
      await repository
          .getApprovedApartments();

      apartments.assignAll(
        result,
      );

    } catch (e) {

      Get.snackbar(

        'Error',

        'Failed to load apartments',

        snackPosition:
        SnackPosition.BOTTOM,
      );

    } finally {

      isLoading.value = false;
    }
  }

  /// load owner apartments
  Future<void> loadOwnerApartments() async {

    try {

      isLoading.value = true;

      final result =
      await repository
          .getOwnerApartments();

      ownerApartments.assignAll(
        result,
      );

    } catch (e) {

      Get.snackbar(

        'Error',

        'Failed to load owner apartments',

        snackPosition:
        SnackPosition.BOTTOM,
      );

    } finally {

      isLoading.value = false;
    }
  }
}