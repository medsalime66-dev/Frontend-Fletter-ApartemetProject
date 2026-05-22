import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class OwnerReservationTile
    extends StatelessWidget {

  final String apartment;

  final String client;

  final String status;

  final String startDate;

  final String endDate;

  const OwnerReservationTile({

    super.key,

    required this.apartment,

    required this.client,

    required this.status,

    required this.startDate,

    required this.endDate,
  });

  Color get statusColor {

    switch (status) {

      case 'CONFIRMED':
        return Colors.green;

      case 'PENDING':
        return Colors.orange;

      case 'CANCELLED':
        return Colors.red;

      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
        AppColors.surface,

        borderRadius:
        BorderRadius.circular(
          22,
        ),

        border: Border.all(
          color:
          AppColors.border,
        ),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              const CircleAvatar(

                backgroundColor:
                AppColors.primary,

                child: Icon(

                  Icons.person,

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

                      apartment,

                      style:
                      const TextStyle(

                        fontWeight:
                        FontWeight.w800,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(

                      client,

                      style:
                      const TextStyle(

                        color:
                        AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),

              Container(

                padding:
                const EdgeInsets.symmetric(

                  horizontal: 12,
                  vertical: 6,
                ),

                decoration:
                BoxDecoration(

                  color:
                  statusColor
                      .withValues(
                    alpha: .12,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    100,
                  ),
                ),

                child: Text(

                  status,

                  style: TextStyle(

                    color:
                    statusColor,

                    fontWeight:
                    FontWeight.bold,
                  ),
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
                Icons.date_range,
                size: 18,
              ),

              const SizedBox(
                width: 8,
              ),

              Expanded(

                child: Text(
                  '$startDate → $endDate',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}