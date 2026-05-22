import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/notification/notification_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class NotificationPage
    extends StatefulWidget {

  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() =>
      _NotificationPageState();
}

class _NotificationPageState
    extends State<NotificationPage> {

  final controller =
  Get.find<NotificationController>();

  @override
  void initState() {

    super.initState();

    controller.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Notifications',
        ),
      ),

      body: Obx(() {

        if (controller
            .isLoading
            .value) {

          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        if (controller
            .notifications
            .isEmpty) {

          return const Center(

            child: Text(
              'No notifications',
            ),
          );
        }

        return RefreshIndicator(

          onRefresh:
          controller.loadNotifications,

          child: ListView.builder(

            padding:
            const EdgeInsets.all(
              AppSpacing.screen,
            ),

            itemCount:
            controller
                .notifications
                .length,

            itemBuilder:
                (context, index) {

              final notification =
              controller
                  .notifications[index];

              return Padding(

                padding:
                const EdgeInsets.only(
                  bottom: 14,
                ),

                child: Material(

                  color:
                  notification.isRead

                      ? AppColors.surface

                      : AppColors.primary
                      .withValues(
                    alpha: .08,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    22,
                  ),

                  child: InkWell(

                    borderRadius:
                    BorderRadius.circular(
                      22,
                    ),

                    onTap: () {

                      if (!notification
                          .isRead) {

                        controller
                            .markAsRead(
                          notification.id,
                        );
                      }
                    },

                    child: Padding(

                      padding:
                      const EdgeInsets.all(
                        18,
                      ),

                      child: Row(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Container(

                            width: 54,
                            height: 54,

                            decoration:
                            BoxDecoration(

                              color:
                              AppColors.primary,

                              borderRadius:
                              BorderRadius.circular(
                                18,
                              ),
                            ),

                            child:
                            const Icon(

                              Icons.notifications,

                              color:
                              Colors.white,
                            ),
                          ),

                          const SizedBox(
                            width: 14,
                          ),

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(

                                  notification.title,

                                  style:
                                  const TextStyle(

                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(

                                  notification.message,

                                  style:
                                  AppTextStyles.body,
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Text(

                                  notification
                                      .createdAt
                                      .toLocal()
                                      .toString()
                                      .replaceFirst('T', ' ')
                                      .substring(0, 16),

                                  style:
                                  AppTextStyles.muted,
                                ),
                              ],
                            ),
                          ),

                          if (!notification
                              .isRead)

                            Container(

                              width: 12,
                              height: 12,

                              decoration:
                              const BoxDecoration(

                                color:
                                AppColors.primary,

                                shape:
                                BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}