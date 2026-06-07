import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites/favorites_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../screens/detail/detail_page.dart';

import '../../widgets/apartment/apartment_card.dart';

class FavoritesPage extends StatelessWidget {

  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller =
    Get.find<FavoritesController>();

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        title: const Text('Favorites'),

        actions: [

          Obx(() {

            if (controller.favorites.isEmpty) {
              return const SizedBox();
            }

            return TextButton(

              onPressed: () async {

                final confirm = await showDialog<bool>(

                  context: context,

                  builder: (ctx) => AlertDialog(

                    title: const Text('Clear Favorites'),

                    content: const Text(
                      'Remove all saved apartments?',
                    ),

                    actions: [

                      TextButton(
                        onPressed: () =>
                            Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),

                      TextButton(
                        onPressed: () =>
                            Navigator.pop(ctx, true),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await controller.clearAll();
                }
              },

              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: AppColors.danger,
                ),
              ),
            );
          }),
        ],
      ),

      body: Obx(() {

        /// فارغة
        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [

                Icon(
                  Icons.favorite_border,
                  size: 72,
                  color: AppColors.border,
                ),

                const SizedBox(height: 20),

                const Text(
                  'No saved apartments',
                  style: AppTextStyles.h3,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Tap the heart icon on any apartment\nto save it here.',
                  style: AppTextStyles.muted,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        /// القائمة
        return ListView(

          padding: const EdgeInsets.all(
            AppSpacing.screen,
          ),

          children: [

            Text(
              '${controller.favorites.length} saved',
              style: AppTextStyles.muted,
            ),

            const SizedBox(height: 16),

            ...controller.favorites.map(
                  (apartment) => Stack(
                children: [

                  ApartmentCard(
                    apartment: apartment,
                    onTap: () {
                      Get.to(
                            () => DetailPage(
                          apartment: apartment,
                        ),
                      );
                    },
                  ),

                  /// زر الإزالة
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () =>
                          controller.toggle(apartment),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: AppColors.danger,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
