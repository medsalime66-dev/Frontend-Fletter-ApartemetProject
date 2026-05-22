import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';

import '../../controllers/apartment/apartment_controller.dart';
import '../../controllers/owner/owner_reservation_controller.dart';
import '../../controllers/notification/notification_controller.dart';

class InitialBinding
    extends Bindings {

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

    Get.put(

      OwnerReservationController(),

      permanent: true,
    );
  }
}