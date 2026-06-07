import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controllers/reservation/my_reservations_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/reservation_model.dart';

class MyReservationsPage extends StatelessWidget {

  const MyReservationsPage({super.key});

  Color _statusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.confirmed:
        return Colors.green;
      case ReservationStatus.checkedIn:
        return AppColors.primary;
      case ReservationStatus.cancelled:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusText(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.checkedIn:
        return 'Checked In';
      case ReservationStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  /// يفتح نافذة QR
  void _showQrDialog(BuildContext context, String qrToken, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                'QR Code',
                style: AppTextStyles.h2,
              ),

              const SizedBox(height: 6),

              Text(
                title,
                style: AppTextStyles.muted,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              /// QR
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: QrImageView(
                  data: qrToken,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'أرِ هذا الكود للمالك عند وصولك',
                style: AppTextStyles.muted,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(MyReservationsController());

    return Scaffold(

      appBar: AppBar(
        title: const Text('My Reservations'),
      ),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reservations.isEmpty) {
          return const Center(
            child: Text('No reservations found'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadReservations,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.reservations.length,
            itemBuilder: (context, index) {

              final reservation = controller.reservations[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// العنوان + الحالة
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [

                              Expanded(
                                child: Text(
                                  reservation.apartmentTitle,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(reservation.status)
                                      .withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _statusText(reservation.status),
                                  style: TextStyle(
                                    color: _statusColor(reservation.status),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// التواريخ
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                size: 16,
                                color: AppColors.muted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${reservation.startDate.toString().split(' ')[0]}'
                                    ' → '
                                    '${reservation.endDate.toString().split(' ')[0]}',
                                style: AppTextStyles.muted,
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// الليالي + السعر
                          Row(
                            children: [
                              const Icon(
                                Icons.nights_stay_outlined,
                                size: 16,
                                color: AppColors.muted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${reservation.nights} nights',
                                style: AppTextStyles.muted,
                              ),
                              const Spacer(),
                              Text(
                                '${reservation.totalPrice.toInt()} MRU',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// زر QR — يظهر فقط إذا الحجز مؤكد وعنده token
                    if (reservation.status == ReservationStatus.confirmed &&
                        reservation.qrToken != null)
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () => _showQrDialog(
                              context,
                              reservation.qrToken!,
                              reservation.apartmentTitle,
                            ),
                            icon: const Icon(
                              Icons.qr_code,
                              color: AppColors.primary,
                            ),
                            label: const Text(
                              'Show QR Code',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                    /// إذا تم الدخول
                    if (reservation.status == ReservationStatus.checkedIn)
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.border),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 18,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Check-in completed',
                              style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}