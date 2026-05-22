import 'package:get/get.dart';

import '../../models/notification_model.dart';

import '../../services/notification_service.dart';

class NotificationController
    extends GetxController {

  final notifications =
      <AppNotification>[].obs;

  final isLoading =
      false.obs;

  /// unread count
  int get unreadCount {

    return notifications
        .where(
          (n) => !n.isRead,
    )
        .length;
  }

  /// load notifications
  Future<void> loadNotifications()
  async {

    try {

      isLoading.value = true;

      final result =
      await NotificationService
          .getNotifications();

      notifications.assignAll(
        result,
      );

    } catch (e) {

      Get.snackbar(

        'Error',

        e.toString(),

        snackPosition:
        SnackPosition.BOTTOM,
      );

    } finally {

      isLoading.value = false;
    }
  }

  /// mark notification read
  Future<void> markAsRead(
      int id,
      ) async {

    try {

      await NotificationService
          .markAsRead(id);

      final index =
      notifications.indexWhere(
            (n) => n.id == id,
      );

      if (index != -1) {

        final old =
        notifications[index];

        notifications[index] =
            AppNotification(

              id: old.id,

              title: old.title,

              message: old.message,

              createdAt:
              old.createdAt,

              isRead: true,
            );
      }

    } catch (e) {

      Get.snackbar(

        'Error',

        e.toString(),

        snackPosition:
        SnackPosition.BOTTOM,
      );
    }
  }
}