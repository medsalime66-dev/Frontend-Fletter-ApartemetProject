import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/primary_button.dart';
import '../home/home_page.dart';

class ConfirmationPage extends StatelessWidget {

  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Padding(

        padding: const EdgeInsets.all(AppSpacing.screen),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            /// أيقونة النجاح
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 60,
              ),
            ),

            const SizedBox(height: 30),

            /// العنوان
            const Text(
              'Booking Confirmed!',
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 14),

            /// الوصف — نص صحيح يعكس الواقع
            Text(
              'Your reservation has been successfully confirmed. You will receive a notification shortly.',
              style: AppTextStyles.muted,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            /// زر حجوزاتي
            PrimaryButton(
              text: 'View My Reservations',
              onPressed: () {
                Get.offAll(() => const HomePage());
              },
            ),

            const SizedBox(height: 14),

            /// زر الرجوع للرئيسية
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  Get.offAll(() => const HomePage());
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}