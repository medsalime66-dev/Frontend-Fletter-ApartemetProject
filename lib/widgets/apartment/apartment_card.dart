import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

class ApartmentCard extends StatelessWidget{

  final ApartmentModel apartment;

  final VoidCallback onTap;

  final VoidCallback? onApprove;

  final bool showApproveButton;

  const ApartmentCard({
    super.key,
    required this.apartment,
    required this.onTap,
    this.onApprove,
    this.showApproveButton=false,
  });

  String get mainImage{

    if(apartment.imageUrls.isEmpty){
      return '';
    }

    return apartment.imageUrls.first;
  }

  @override
  Widget build(BuildContext context){

    return GestureDetector(

      onTap:onTap,

      child:Container(

        margin:const EdgeInsets.only(
          bottom:AppSpacing.lg,
        ),

        decoration:BoxDecoration(

          color:AppColors.surface,

          borderRadius:
          BorderRadius.circular(
            AppRadius.lg,
          ),

          border:Border.all(
            color:AppColors.border,
          ),
        ),

        child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[

//image
            ClipRRect(

              borderRadius:
              const BorderRadius.vertical(
                top:Radius.circular(
                  AppRadius.lg,
                ),
              ),

              child:

              mainImage.isNotEmpty

                  ?Image.network(

                mainImage,

                height:220,

                width:double.infinity,

                fit:BoxFit.cover,

                errorBuilder:
                    (_,__,___){

                  return Container(

                    height:220,

                    color:AppColors.border,

                    child:const Center(

                      child:Icon(
                        Icons.image_not_supported,
                        size:70,
                      ),
                    ),
                  );
                },
              )

                  :Container(

                height:220,

                color:AppColors.border,

                child:const Center(

                  child:Icon(
                    Icons.apartment,
                    size:70,
                  ),
                ),
              ),
            ),

            Padding(

              padding:const EdgeInsets.all(
                AppSpacing.md,
              ),

              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

//title
                  Text(
                    apartment.title,
                    style:AppTextStyles.h3,
                  ),

                  const SizedBox(height:8),

//location
                  Text(

                    "${apartment.city}, ${apartment.district}",

                    style:AppTextStyles.muted,
                  ),

                  const SizedBox(height:14),

//description
                  Text(
                    apartment.description,
                    maxLines:2,
                    overflow:TextOverflow.ellipsis,
                  ),

                  const SizedBox(height:18),

//stats
                  Row(

                    children:[

                      _buildStat(
                        Icons.bed,
                        '${apartment.rooms}',
                      ),

                      const SizedBox(width:16),

                      _buildStat(
                        Icons.bathtub,
                        '${apartment.bathrooms}',
                      ),

                      const SizedBox(width:16),

                      _buildStat(
                        Icons.square_foot,
                        '${apartment.area}',
                      ),
                    ],
                  ),

                  const SizedBox(height:18),

//footer
                  Row(

                    children:[

//price
                      Expanded(

                        child:Text(

                          "${apartment.pricePerNight} MRU",

                          style:const TextStyle(
                            fontSize:18,
                            fontWeight:FontWeight.bold,
                            color:AppColors.primary,
                          ),
                        ),
                      ),

//status
                      Container(

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal:12,
                          vertical:6,
                        ),

                        decoration:BoxDecoration(

                          color:
                          apartment.status=='APPROVED'
                              ?Colors.green.shade100
                              :Colors.orange.shade100,

                          borderRadius:
                          BorderRadius.circular(100),
                        ),

                        child:Text(
                          apartment.status,
                        ),
                      ),
                    ],
                  ),

                  if(showApproveButton)...[

                    const SizedBox(height:16),

                    SizedBox(

                      width:double.infinity,

                      child:ElevatedButton(

                        onPressed:onApprove,

                        child:const Text(
                          'Approve Apartment',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
      IconData icon,
      String value,
      ){

    return Row(

      children:[

        Icon(
          icon,
          size:18,
        ),

        const SizedBox(width:6),

        Text(value),
      ],
    );
  }
}