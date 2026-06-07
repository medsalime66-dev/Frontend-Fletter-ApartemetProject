import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'register_page.dart';
import 'owner_redirect_page.dart';

class RegisterChoosePage extends StatefulWidget {
  const RegisterChoosePage({super.key});

  @override
  State<RegisterChoosePage> createState() =>
      _RegisterChoosePageState();
}

class _RegisterChoosePageState
    extends State<RegisterChoosePage> {

  String _selected = 'client';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              /// Back
              GestureDetector(
                onTap: Get.back,
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios_new,
                        size: 18, color: Colors.grey),
                    SizedBox(width: 6),
                    Text('Retour',
                        style:
                        TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'create_account'.tr,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Qui êtes-vous ?',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 32),

              /// CLIENT card
              GestureDetector(
                onTap: () => setState(() => _selected = 'client'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _selected == 'client'
                        ? const Color(0xFF1a1a1a)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selected == 'client'
                          ? const Color(0xFF1a1a1a)
                          : const Color(0xFFEAE5DB),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9A86A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _selected == 'client'
                                    ? Colors.white
                                    : const Color(0xFF1a1a1a),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cherchez & réservez des appartements',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _RadioDot(selected: _selected == 'client'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// OWNER card
              GestureDetector(
                onTap: () => setState(() => _selected = 'owner'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _selected == 'owner'
                        ? const Color(0xFF1a1a1a)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selected == 'owner'
                          ? const Color(0xFF1a1a1a)
                          : const Color(0xFFEAE5DB),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _selected == 'owner'
                              ? const Color(0xFFC9A86A)
                              : const Color(0xFFF5F2EC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.apartment_outlined,
                          color: _selected == 'owner'
                              ? Colors.white
                              : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Propriétaire',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _selected == 'owner'
                                    ? Colors.white
                                    : const Color(0xFF1a1a1a),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Publiez & gérez vos appartements',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _RadioDot(selected: _selected == 'owner'),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// Continue
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selected == 'client') {
                      Get.to(() => const RegisterPage());
                    } else {
                      Get.to(() => const OwnerRedirectPage());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9A86A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? const Color(0xFFC9A86A)
            : Colors.transparent,
        border: Border.all(
          color: selected
              ? const Color(0xFFC9A86A)
              : const Color(0xFFE9E4DA),
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 13, color: Colors.white)
          : null,
    );
  }
}