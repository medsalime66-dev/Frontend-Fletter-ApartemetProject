import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/notification/notification_controller.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class OwnerNotificationsPage
    extends StatefulWidget {

  const OwnerNotificationsPage({
    super.key,
  });

  @override
  State<OwnerNotificationsPage>
  createState() =>
      _OwnerNotificationsPageState();
}

class _OwnerNotificationsPageState
    extends State<
        OwnerNotificationsPage> {

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

        /// loading
        if (controller
            .isLoading
            .value) {

          return const Center(

            child:
            CircularProgressIndicator(),
          );
        }

        /// empty
        if (controller
            .notifications
            .isEmpty) {

          return const Center(

            child: Text(

              'No notifications',

              style:
              AppTextStyles.body,
            ),
          );
        }

        /// list
        return RefreshIndicator(

          onRefresh: () async {

            await controller
                .loadNotifications();
          },

          child: ListView.separated(

            padding:
            const EdgeInsets.all(
              AppSpacing.screen,
            ),

            itemCount:
            controller
                .notifications
                .length,

            separatorBuilder:
                (_, __) {

              return const SizedBox(
                height: 14,
              );
            },

            itemBuilder:
                (context, index) {

              final notification =
              controller
                  .notifications[index];

              return Container(

                padding:
                const EdgeInsets.all(
                  18,
                ),

                decoration:
                BoxDecoration(

                  color:
                  notification.isRead

                      ? Colors.white

                      : const Color(
                    0xFFF9F4E8,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),

                  border: Border.all(

                    color:
                    const Color(
                      0xFFE8D9A8,
                    ),
                  ),
                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Row(

                      children: [

                        const Icon(

                          Icons
                              .notifications,

                          color:
                          Color(
                            0xFFC8A54B,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(

                          child: Text(

                            notification
                                .title,

                            style:
                            const TextStyle(

                              fontSize: 16,

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(

                      notification
                          .message,

                      style:
                      AppTextStyles.body,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(

                      notification
                          .createdAt
                          .toString()
                          .substring(0, 16),

                      style: const TextStyle(

                        fontSize: 12,

                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}