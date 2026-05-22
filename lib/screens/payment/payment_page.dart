import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/reservation/reservation_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../data/mock_payments.dart';

import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/primary_button.dart';

import '../../widgets/payment/wallet_option_card.dart';

import '../confirmation/confirmation_page.dart';

class PaymentPage
    extends StatefulWidget {

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

  final reservationController =
  Get.find<ReservationController>();

  String selectedWallet =
      mockWallets.first.name;

  final phoneController =
  TextEditingController();

  final codeController =
  TextEditingController();

  @override
  void dispose() {

    phoneController.dispose();

    codeController.dispose();

    super.dispose();
  }

  /// confirm payment
  Future<void> confirmPayment() async {

    if (phoneController.text.isEmpty ||
        codeController.text.isEmpty) {

      Get.snackbar(

        'Error',

        'Please fill all fields',

        snackPosition:
        SnackPosition.BOTTOM,
      );

      return;
    }

    try {

      /// simulate payment
      await Future.delayed(
        const Duration(seconds: 2),
      );

      /// create reservation
      final success =
      await reservationController
          .createReservation();

      if (!mounted) {
        return;
      }

      if (success) {

        Get.offAll(
              () =>
          const ConfirmationPage(),
        );

        return;
      }

      Get.snackbar(

        'Error',

        'Reservation failed',

        snackPosition:
        SnackPosition.BOTTOM,
      );

    } catch (e) {

      Get.snackbar(

        'Payment Error',

        e.toString(),

        snackPosition:
        SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(

          'Payment',

          style:
          AppTextStyles.h2,
        ),
      ),

      body: ListView(

        padding:
        const EdgeInsets.all(
          AppSpacing.screen,
        ),

        children: [

          /// payment card
          Container(

            padding:
            const EdgeInsets.all(
              24,
            ),

            decoration:
            BoxDecoration(

              color:
              AppColors.text,

              borderRadius:
              BorderRadius.circular(
                28,
              ),
            ),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(

                  'Total Amount',

                  style: TextStyle(
                    color:
                    Colors.white70,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(

                  '${widget.total} MRU',

                  style:
                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize: 34,

                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(

                  'Owner Wallet: ${widget.apartment.walletCode}',

                  style:
                  const TextStyle(
                    color:
                    Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 28,
          ),

          /// wallet title
          const Text(

            'Wallet',

            style:
            AppTextStyles.h2,
          ),

          const SizedBox(
            height: 14,
          ),

          /// wallets
          ...mockWallets.map((wallet) {

            return Padding(

              padding:
              const EdgeInsets.only(
                bottom: 12,
              ),

              child: WalletOptionCard(

                name:
                wallet.name,

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

          const SizedBox(
            height: 20,
          ),

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

          const SizedBox(
            height: 14,
          ),

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

          const SizedBox(
            height: 28,
          ),

          /// button
          Obx(() {

            return PrimaryButton(

              text:

              reservationController
                  .isLoading
                  .value

                  ? 'Processing...'

                  : 'Confirm Payment',

              onPressed:

              reservationController
                  .isLoading
                  .value

                  ? null

                  : confirmPayment,
            );
          }),
        ],
      ),
    );
  }
}