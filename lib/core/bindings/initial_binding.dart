import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../controllers/apartment/apartment_controller.dart';
import '../../controllers/favorites/favorites_controller.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../controllers/owner/owner_reservation_controller.dart';
import '../../controllers/settings/settings_controller.dart';

class InitialBinding extends Bindings {

  @override
  void dependencies() {

    /// auth
    Get.put(
      AuthController(),
      permanent: true,
    );

    /// apartments
    Get.put(
      ApartmentController(),
      permanent: true,
    );

    /// notifications
    Get.put(
      NotificationController(),
      permanent: true,
    );

    /// owner reservations
    Get.put(
      OwnerReservationController(),
      permanent: true,
    );

    /// favorites
    Get.put(
      FavoritesController(),
      permanent: true,
    );

    /// settings
    Get.put(
      SettingsController(),
      permanent: true,
    );
  }
}
