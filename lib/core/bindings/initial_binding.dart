import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';

import '../../controllers/apartment/apartment_controller.dart';

class InitialBinding
    extends Bindings {

  @override
  void dependencies() {

    Get.put(

      AuthController(),

      permanent: true,
    );

    Get.put(

      ApartmentController(),

      permanent: true,
    );
  }
}