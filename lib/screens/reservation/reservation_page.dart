import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../services/reservation_service.dart';

import '../confirmation/confirmation_page.dart';

class ReservationPage extends StatefulWidget {

  final ApartmentModel apartment;

  const ReservationPage({
    super.key,
    required this.apartment,
  });

  @override
  State<ReservationPage> createState() =>
      _ReservationPageState();
}

class _ReservationPageState
    extends State<ReservationPage> {

  bool isLoading = false;

  DateTime? startDate;

  DateTime? endDate;

  /// pick reservation dates
  Future<void> pickDateRange() async {

    final picked =
    await showDateRangePicker(

      context: context,

      firstDate: DateTime.now(),

      lastDate: DateTime(2030),

      builder: (context, child) {

        return Theme(

          data: Theme.of(context).copyWith(

            colorScheme: const ColorScheme.light(

              primary: AppColors.primary,
            ),
          ),

          child: child!,
        );
      },
    );

    if (picked != null) {

      setState(() {

        startDate = picked.start;

        endDate = picked.end;
      });
    }
  }

  /// calculate nights
  int get nights {

    if (startDate == null || endDate == null) {
      return 0;
    }

    return endDate!
        .difference(startDate!)
        .inDays;
  }

  /// calculate total
  double get total {

    return nights *
        widget.apartment.pricePerNight;
  }

  /// confirm reservation
  Future<void> reserve() async {

    if (startDate == null ||
        endDate == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Please select reservation dates',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final success =
      await ReservationService
          .createReservation(

        apartmentId:
        widget.apartment.id,

        startDate:
        startDate!
            .toIso8601String()
            .split('T')[0],

        endDate:
        endDate!
            .toIso8601String()
            .split('T')[0],
      );

      if (!mounted) {
        return;
      }

      if (success) {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
            const ConfirmationPage(),
          ),
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
          'Reservation',
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(
          AppSpacing.screen,
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// title
            Text(
              widget.apartment.title,
              style: AppTextStyles.h1,
            ),

            const SizedBox(height: 12),

            /// location
            Row(

              children: [

                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: AppColors.primary,
                ),

                const SizedBox(width: 6),

                Expanded(

                  child: Text(

                    "${widget.apartment.city}, ${widget.apartment.district}",

                    style:
                    AppTextStyles.muted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// date picker
            InkWell(

              onTap: pickDateRange,

              borderRadius:
              BorderRadius.circular(22),

              child: Container(

                padding:
                const EdgeInsets.all(18),

                decoration: BoxDecoration(

                  color: AppColors.surface,

                  borderRadius:
                  BorderRadius.circular(22),

                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),

                child: Row(

                  children: [

                    const Icon(
                      Icons.date_range,
                    ),

                    const SizedBox(width: 14),

                    Expanded(

                      child: Text(

                        startDate == null

                            ? 'Select reservation dates'

                            : '${startDate!.toString().split(' ')[0]} → ${endDate!.toString().split(' ')[0]}',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            /// summary
            Container(

              padding:
              const EdgeInsets.all(22),

              decoration: BoxDecoration(

                color: AppColors.surface,

                borderRadius:
                BorderRadius.circular(24),

                border: Border.all(
                  color: AppColors.border,
                ),
              ),

              child: Column(

                children: [

                  /// price
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(
                        'Price Per Night',
                      ),

                      Text(
                        "${widget.apartment.pricePerNight} MRU",
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// nights
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(
                        'Nights',
                      ),

                      Text(
                        nights.toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// wallet
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(
                        'Wallet',
                      ),

                      Text(
                        widget.apartment.walletCode,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// total
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(

                        'Total',

                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Text(

                        "$total MRU",

                        style: const TextStyle(

                          fontWeight:
                          FontWeight.bold,

                          fontSize: 22,

                          color:
                          AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// button
            SizedBox(

              width: double.infinity,

              height: 58,

              child: ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : reserve,

                child: Text(

                  isLoading
                      ? 'Loading...'
                      : 'Confirm Reservation',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}