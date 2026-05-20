import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../widgets/apartment/apartment_gallery.dart';
import '../../widgets/apartment/amenity_chip.dart';

import '../reservation/reservation_page.dart';

class DetailPage extends StatelessWidget{

  final ApartmentModel apartment;

  const DetailPage({
    super.key,
    required this.apartment,
  });

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:
      AppColors.background,

      body:CustomScrollView(

        slivers:[

//app bar
          SliverAppBar(

            expandedHeight:320,

            pinned:true,

            backgroundColor:
            AppColors.surface,

            iconTheme:const IconThemeData(
              color:Colors.white,
            ),

            flexibleSpace:FlexibleSpaceBar(

              background:
              ApartmentGallery(
                images:apartment.imageUrls,
              ),
            ),
          ),

//content
          SliverToBoxAdapter(

            child:Padding(

              padding:const EdgeInsets.all(
                AppSpacing.screen,
              ),

              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

//title
                  Text(
                    apartment.title,
                    style:AppTextStyles.h1,
                  ),

                  const SizedBox(height:10),

//location
                  Row(

                    children:[

                      const Icon(
                        Icons.location_on,
                        size:18,
                        color:AppColors.primary,
                      ),

                      const SizedBox(width:6),

                      Expanded(

                        child:Text(

                          "${apartment.city}, ${apartment.district}",

                          style:AppTextStyles.muted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height:26),

//description card
                  Container(

                    padding:const EdgeInsets.all(20),

                    decoration:BoxDecoration(

                      color:AppColors.surface,

                      borderRadius:
                      BorderRadius.circular(24),

                      border:Border.all(
                        color:AppColors.border,
                      ),
                    ),

                    child:Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children:[

                        const Text(
                          'Description',
                          style:AppTextStyles.h3,
                        ),

                        const SizedBox(height:14),

                        Text(
                          apartment.description,
                          style:AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height:24),

//features
                  Container(

                    padding:const EdgeInsets.all(20),

                    decoration:BoxDecoration(

                      color:AppColors.surface,

                      borderRadius:
                      BorderRadius.circular(24),

                      border:Border.all(
                        color:AppColors.border,
                      ),
                    ),

                    child:Wrap(

                      spacing:12,

                      runSpacing:12,

                      children:[

                        AmenityChip(
                          icon:Icons.bed,
                          label:
                          "${apartment.rooms} Rooms",
                        ),

                        AmenityChip(
                          icon:Icons.bathtub,
                          label:
                          "${apartment.bathrooms} Bathrooms",
                        ),

                        AmenityChip(
                          icon:Icons.square_foot,
                          label:
                          "${apartment.area} m²",
                        ),

                        AmenityChip(
                          icon:Icons.wallet,
                          label:
                          apartment.walletCode,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height:24),

//owner card
                  Container(

                    padding:const EdgeInsets.all(20),

                    decoration:BoxDecoration(

                      color:AppColors.surface,

                      borderRadius:
                      BorderRadius.circular(24),

                      border:Border.all(
                        color:AppColors.border,
                      ),
                    ),

                    child:Column(

                      children:[

//owner
                        Row(

                          children:[

                            const CircleAvatar(

                              backgroundColor:
                              AppColors.primary,

                              child:Icon(
                                Icons.person,
                                color:Colors.white,
                              ),
                            ),

                            const SizedBox(width:14),

                            Expanded(

                              child:Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children:[

                                  const Text(
                                    'Owner',
                                    style:
                                    AppTextStyles.muted,
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

                        const SizedBox(height:18),

//phone
                        Row(

                          children:[

                            const Icon(
                              Icons.phone,
                              color:
                              AppColors.primary,
                            ),

                            const SizedBox(width:12),

                            Text(
                              apartment.ownerPhone,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height:28),

//price + reservation
                  Container(

                    padding:const EdgeInsets.all(20),

                    decoration:BoxDecoration(

                      color:AppColors.surface,

                      borderRadius:
                      BorderRadius.circular(24),

                      border:Border.all(
                        color:AppColors.border,
                      ),
                    ),

                    child:Row(

                      children:[

//price
                        Expanded(

                          child:Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children:[

                              const Text(
                                'Price Per Night',
                                style:
                                AppTextStyles.muted,
                              ),

                              const SizedBox(height:4),

                              Text(

                                "${apartment.pricePerNight} MRU",

                                style:const TextStyle(

                                  fontSize:26,

                                  fontWeight:
                                  FontWeight.w900,

                                  color:
                                  AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),

//button
                        Expanded(

                          child:SizedBox(

                            height:56,

                            child:ElevatedButton(

                              onPressed:(){

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder:(_)=>ReservationPage(
                                      apartment:apartment,
                                    ),
                                  ),
                                );
                              },

                              style:ElevatedButton.styleFrom(

                                backgroundColor:
                                AppColors.primary,

                                shape:
                                RoundedRectangleBorder(

                                  borderRadius:
                                  BorderRadius.circular(18),
                                ),
                              ),

                              child:const Text(
                                'Reserve',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height:40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}