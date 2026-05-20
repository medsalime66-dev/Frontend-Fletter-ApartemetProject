import 'package:flutter/material.dart';

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
            const CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.text,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Réservation envoyée',
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Votre demande est maintenant en attente de confirmation.',
              style: AppTextStyles.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 34),
            PrimaryButton(
              text: 'Retour accueil',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}