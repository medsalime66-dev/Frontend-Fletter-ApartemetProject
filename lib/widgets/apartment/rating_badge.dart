import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class RatingBadge extends StatelessWidget {
  final double rating;

  const RatingBadge({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            rating.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}