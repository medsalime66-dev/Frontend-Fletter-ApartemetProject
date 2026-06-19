import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerRedirectPage extends StatelessWidget {

  const OwnerRedirectPage({super.key});

  static const String _registerUrl =
      'http://backend-fletter-apartemetproject-production.up.railway.app/owner/register';

  Future<void> _openWeb() async {
    final uri = Uri.parse(_registerUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _registerUrl));
    if (context.mounted) {
      Get.snackbar(
        'Copié',
        'Lien copié dans le presse-papiers',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFA),
      body: Column(
        children: [

          /// Dark header
          Container(
            color: const Color(0xFF1a1a1a),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 14,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back_ios_new,
                          size: 18, color: Color(0xFF666666)),
                      SizedBox(width: 6),
                      Text('Retour',
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF666666))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9A86A)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: const Color(0xFFC9A86A)
                                .withValues(alpha: 0.3)),
                      ),
                      child: const Icon(
                        Icons.apartment,
                        color: Color(0xFFC9A86A),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Compte propriétaire',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Inscription via le site web',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF666666)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 4),

                  /// Info box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F2EC),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xFFC9A86A), size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  height: 1.6),
                              children: [
                                TextSpan(
                                    text:
                                    'Votre compte vous donnera accès à votre espace sur le '),
                                TextSpan(
                                  text: 'site web',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1a1a1a),
                                  ),
                                ),
                                TextSpan(text: ' et sur '),
                                TextSpan(
                                  text: "l'application",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1a1a1a),
                                  ),
                                ),
                                TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Steps
                  _buildStep('1', 'Créez votre compte sur le site'),
                  const SizedBox(height: 14),
                  _buildStep(
                      '2', 'Connectez-vous ici avec vos identifiants'),
                  const SizedBox(height: 14),
                  _buildStep(
                      '3', 'Gérez vos appartements depuis partout'),

                  const SizedBox(height: 24),

                  /// Link card
                  GestureDetector(
                    onTap: _openWeb,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFEAE5DB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lien d\'inscription propriétaire',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _registerUrl,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFC9A86A),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _copyLink(context),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(Icons.copy_outlined,
                                      size: 20, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Open button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _openWeb,
                      icon: const Icon(
                        Icons.open_in_new,
                        color: Color(0xFFC9A86A),
                        size: 20,
                      ),
                      label: const Text(
                        'Ouvrir le site web',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a1a1a),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Color(0xFF1a1a1a),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFC9A86A),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
              fontSize: 14, color: Color(0xFF555555)),
        ),
      ],
    );
  }
}