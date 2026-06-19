import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/apartment/apartment_controller.dart';
import '../../controllers/favorites/favorites_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../repositories/apartment_repository.dart';

import '../../widgets/apartment/apartment_gallery.dart';
import '../../widgets/apartment/amenity_chip.dart';

import '../../screens/owner/create_apartment_page.dart';
import '../../screens/reservation/reservation_page.dart';

class DetailPage extends StatelessWidget {

  final ApartmentModel apartment;
  final bool isOwner;

  const DetailPage({
    super.key,
    required this.apartment,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {

    final favController =
    Get.find<FavoritesController>();

    return Scaffold(

      backgroundColor: AppColors.background,

      body: CustomScrollView(

        slivers: [

          /// ===== APP BAR =====
          SliverAppBar(

            expandedHeight: 360,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor:
                Colors.black.withValues(alpha: 0.35),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            actions: [
              if (!isOwner)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Obx(() {
                    final isFav =
                    favController.isFavorite(apartment.id);
                    return GestureDetector(
                      onTap: () =>
                          favController.toggle(apartment),
                      child: CircleAvatar(
                        backgroundColor:
                        Colors.black.withValues(alpha: 0.35),
                        child: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFav
                              ? AppColors.danger
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: ApartmentGallery(
                images: apartment.imageUrls,
              ),
            ),
          ),

          /// ===== CONTENT =====
          SliverToBoxAdapter(

            child: Padding(

              padding: const EdgeInsets.all(AppSpacing.screen),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  /// العنوان + الحالة
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          apartment.title,
                          style: AppTextStyles.h1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success
                              .withValues(alpha: 0.12),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Available',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// الموقع
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${apartment.city}, ${apartment.district}',
                          style: AppTextStyles.muted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// مميزات — 3 بطاقات
                  Row(
                    children: [
                      _buildFeatureBox(
                        icon: Icons.bed_outlined,
                        value: '${apartment.rooms}',
                        label: 'Rooms',
                      ),
                      const SizedBox(width: 12),
                      _buildFeatureBox(
                        icon: Icons.bathtub_outlined,
                        value: '${apartment.bathrooms}',
                        label: 'Bathrooms',
                      ),
                      const SizedBox(width: 12),
                      _buildFeatureBox(
                        icon: Icons.square_foot,
                        value: '${apartment.area}',
                        label: 'm²',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// الوصف
                  _buildCard(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          apartment.description,
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// المحفظة
                  _buildCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withValues(alpha: 0.12),
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.wallet,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Wallet code',
                              style: AppTextStyles.muted,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              apartment.walletCode,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// المالك
                  if (!isOwner)
                    _buildCard(
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Owner',
                                  style: AppTextStyles.muted,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  apartment.ownerName,
                                  style: AppTextStyles.h3,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_outlined,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      apartment.ownerPhone,
                                      style: AppTextStyles.muted,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (!isOwner) const SizedBox(height: 14),

                  /// السعر + زر الحجز
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.text,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Price per night',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${apartment.pricePerNight} MRU',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isOwner) {
                                await Get.to(
                                      () => CreateApartmentPage(
                                    editApartment: apartment,
                                  ),
                                );
                                Get.find<ApartmentController>()
                                    .loadOwnerApartments();
                                return;
                              }
                              Get.to(
                                    () => ReservationPage(
                                  apartment: apartment,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              isOwner
                                  ? 'Edit Apartment'
                                  : 'Reserve Now',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isOwner) const SizedBox(height: 14),

                  if (isOwner)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => _confirmDelete(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: const BorderSide(
                            color: AppColors.danger,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'delete'.tr,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('delete_apartment'.tr),
        content: Text('delete_apartment_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    try {

      await ApartmentRepository().deleteApartment(apartment.id);

      Get.back();

      Get.find<ApartmentController>().loadOwnerApartments();

      Get.snackbar(
        'delete_apartment'.tr,
        'apartment_deleted'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {

      Get.snackbar(
        'failed'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildFeatureBox({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(label, style: AppTextStyles.muted),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}