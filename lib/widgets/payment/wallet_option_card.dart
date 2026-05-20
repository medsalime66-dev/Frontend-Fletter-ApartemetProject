import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class WalletOptionCard extends StatelessWidget {
  final String name;

  final bool selected;

  final VoidCallback? onTap;

  const WalletOptionCard({
    super.key,
    required this.name,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.text
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.text
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              color: selected
                  ? Colors.white
                  : AppColors.text,
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : AppColors.text,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}