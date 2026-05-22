import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ReservationSummary
    extends StatelessWidget {

  final int nights;

  final int total;

  const ReservationSummary({

    super.key,

    required this.nights,

    required this.total,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: AppColors.surface,

        borderRadius:
        BorderRadius.circular(24),

        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            '$nights nuits',

            style: const TextStyle(

              color: AppColors.muted,

              fontSize: 16,
            ),
          ),

          const SizedBox(height: 14),

          FittedBox(

            fit: BoxFit.scaleDown,

            alignment:
            Alignment.centerLeft,

            child: Text(

              '$total MRU',

              style: const TextStyle(

                fontSize: 30,

                fontWeight:
                FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}