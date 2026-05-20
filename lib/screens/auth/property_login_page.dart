import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/primary_button.dart';

class PropertyLoginPage extends StatelessWidget {
  const PropertyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Espace propriétaire',
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 8),
              Text(
                'Connexion réservée aux propriétaires validés par l’administration.',
                style: AppTextStyles.muted,
              ),
              const SizedBox(height: 32),

              const AppTextField(
                label: 'Numéro de téléphone',
                icon: Icons.phone_outlined,
                isPhone: true,
              ),

              const SizedBox(height: 14),

              const AppTextField(
                label: 'Code propriétaire',
                icon: Icons.lock_outline,
                isPassword: true,
                isNumeric: true,
                maxLength: 6,
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Entrer',
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
      ),
    );
  }
}