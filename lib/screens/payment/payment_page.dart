import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../data/mock_payments.dart';

import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/primary_button.dart';

import '../../widgets/payment/wallet_option_card.dart';

import '../../services/reservation_service.dart';

import '../confirmation/confirmation_page.dart';

class PaymentPage extends StatefulWidget {

  final ApartmentModel apartment;

  final int total;

  final DateTime startDate;

  final DateTime endDate;

  const PaymentPage({
    super.key,
    required this.apartment,
    required this.total,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<PaymentPage> createState() =>
      _PaymentPageState();
}

class _PaymentPageState
    extends State<PaymentPage> {

  String selectedWallet =
      mockWallets.first.name;

  final phoneController =
  TextEditingController();

  final codeController =
  TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {

    phoneController.dispose();
    codeController.dispose();

    super.dispose();
  }

  Future<void> confirmPayment() async {

    if (phoneController.text.isEmpty ||
        codeController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Please fill all fields',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      /// simulate payment success

      await Future.delayed(
        const Duration(seconds: 2),
      );

      /// create reservation ONLY after payment

      final success =
      await ReservationService
          .createReservation(

        apartmentId:
        widget.apartment.id,

        startDate:
        widget.startDate
            .toIso8601String()
            .split('T')[0],

        endDate:
        widget.endDate
            .toIso8601String()
            .split('T')[0],
      );

      if (!mounted) return;

      if (success) {

        Navigator.pushAndRemoveUntil(

          context,

          MaterialPageRoute(

            builder: (_) =>
            const ConfirmationPage(),
          ),

              (route) => false,
        );

        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Reservation failed',
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Payment',
          style: AppTextStyles.h2,
        ),
      ),

      body: ListView(

        padding: const EdgeInsets.all(
          AppSpacing.screen,
        ),

        children: [

          /// card
          Container(

            padding:
            const EdgeInsets.all(24),

            decoration: BoxDecoration(

              color: AppColors.text,

              borderRadius:
              BorderRadius.circular(28),
            ),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(

                  'Total Amount',

                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 8),

                Text(

                  '${widget.total} MRU',

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 34,

                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                Text(

                  'Owner Wallet: ${widget.apartment.walletCode}',

                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// wallets
          const Text(
            'Wallet',
            style: AppTextStyles.h2,
          ),

          const SizedBox(height: 14),

          ...mockWallets.map((wallet) {

            return Padding(

              padding:
              const EdgeInsets.only(
                bottom: 12,
              ),

              child: WalletOptionCard(

                name: wallet.name,

                selected:
                selectedWallet ==
                    wallet.name,

                onTap: () {

                  setState(() {

                    selectedWallet =
                        wallet.name;
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 20),

          /// phone
          AppTextField(

            controller:
            phoneController,

            label:
            'Phone Number',

            icon:
            Icons.phone_outlined,

            isPhone: true,
          ),

          const SizedBox(height: 14),

          /// code
          AppTextField(

            controller:
            codeController,

            label:
            'B-Pay Code',

            icon:
            Icons.password_outlined,

            isPassword: true,

            isNumeric: true,

            maxLength: 4,
          ),

          const SizedBox(height: 28),

          /// button
          PrimaryButton(

            text:
            isLoading
                ? 'Processing...'
                : 'Confirm Payment',

            onPressed:
            isLoading
                ? null
                : confirmPayment,
          ),
        ],
      ),
    );
  }
}