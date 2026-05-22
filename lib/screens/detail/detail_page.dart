import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../widgets/apartment/apartment_gallery.dart';
import '../../widgets/apartment/amenity_chip.dart';

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

    return Scaffold(

      backgroundColor:
      AppColors.background,

      body: CustomScrollView(

        slivers: [

          /// APP BAR
          SliverAppBar(

            expandedHeight: 340,

            pinned: true,

            elevation: 0,

            backgroundColor:
            AppColors.surface,

            iconTheme:
            const IconThemeData(
              color: Colors.white,
            ),

            flexibleSpace:
            FlexibleSpaceBar(

              background:
              ApartmentGallery(
                images:
                apartment.imageUrls,
              ),
            ),
          ),

          /// CONTENT
          SliverToBoxAdapter(

            child: Padding(

              padding:
              const EdgeInsets.all(
                AppSpacing.screen,
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// TITLE
                  Text(

                    apartment.title,

                    style:
                    AppTextStyles.h1,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  /// LOCATION
                  Row(

                    children: [

                      const Icon(

                        Icons.location_on,

                        size: 18,

                        color:
                        AppColors.primary,
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      Expanded(

                        child: Text(

                          "${apartment.city}, ${apartment.district}",

                          style:
                          AppTextStyles.muted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  /// DESCRIPTION
                  _buildSectionCard(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(

                          'Description',

                          style:
                          AppTextStyles.h3,
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        Text(

                          apartment.description,

                          style:
                          AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  /// FEATURES
                  _buildSectionCard(

                    child: Wrap(

                      spacing: 12,

                      runSpacing: 12,

                      children: [

                        AmenityChip(

                          icon:
                          Icons.bed,

                          label:
                          "${apartment.rooms} Rooms",
                        ),

                        AmenityChip(

                          icon:
                          Icons.bathtub,

                          label:
                          "${apartment.bathrooms} Bathrooms",
                        ),

                        AmenityChip(

                          icon:
                          Icons.square_foot,

                          label:
                          "${apartment.area} m²",
                        ),

                        AmenityChip(

                          icon:
                          Icons.wallet,

                          label:
                          apartment.walletCode,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  /// OWNER CARD
                  if (!isOwner)
                    _buildSectionCard(

                      child: Column(

                        children: [

                          Row(

                            children: [

                              Container(

                                width: 58,
                                height: 58,

                                decoration:
                                BoxDecoration(

                                  color:
                                  AppColors.primary,

                                  borderRadius:
                                  BorderRadius.circular(18),
                                ),

                                child:
                                const Icon(

                                  Icons.person,

                                  color:
                                  Colors.white,

                                  size: 28,
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

                                    const Text(

                                      'Owner',

                                      style:
                                      AppTextStyles.muted,
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Text(

                                      apartment.ownerName,

                                      style:
                                      AppTextStyles.h3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          Row(

                            children: [

                              const Icon(

                                Icons.phone,

                                color:
                                AppColors.primary,
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Text(
                                apartment.ownerPhone,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  if (!isOwner)
                    const SizedBox(
                      height: 28,
                    ),

                  /// PRICE + ACTION
                  Container(

                    padding:
                    const EdgeInsets.all(
                      20,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      AppColors.surface,

                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),

                      border:
                      Border.all(
                        color:
                        AppColors.border,
                      ),
                    ),

                    child: Column(

                      children: [

                        Row(

                          children: [

                            const Text(

                              'Price Per Night',

                              style:
                              AppTextStyles.muted,
                            ),

                            const Spacer(),

                            Text(

                              "${apartment.pricePerNight} MRU",

                              style:
                              const TextStyle(

                                fontSize: 25,

                                fontWeight:
                                FontWeight.w900,

                                color:
                                AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        SizedBox(

                          width:
                          double.infinity,

                          height: 58,

                          child: ElevatedButton(

                            onPressed: () {

                              if (isOwner) {

                                Get.snackbar(

                                  'Edit',

                                  'Edit page coming soon',

                                  snackPosition:
                                  SnackPosition.BOTTOM,
                                );

                                return;
                              }

                              Get.to(
                                    () => ReservationPage(
                                  apartment:
                                  apartment,
                                ),
                              );
                            },

                            style:
                            ElevatedButton.styleFrom(

                              backgroundColor:
                              AppColors.primary,

                              elevation: 0,

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(
                                  18,
                                ),
                              ),
                            ),

                            child: Text(

                              isOwner
                                  ? 'Edit Apartment'
                                  : 'Reserve',

                              style: const TextStyle(

                                fontSize: 18,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required Widget child,
  }) {

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration:
      BoxDecoration(

        color:
        AppColors.surface,

        borderRadius:
        BorderRadius.circular(24),

        border:
        Border.all(
          color:
          AppColors.border,
        ),
      ),

      child: child,
    );
  }
}