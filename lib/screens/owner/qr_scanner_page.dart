import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class QrScannerPage extends StatefulWidget {

  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {

  final MobileScannerController _scanner = MobileScannerController();

  bool _isProcessing = false;
  bool _scanned = false;

  @override
  void dispose() {
    _scanner.dispose();
    super.dispose();
  }

  /// إرسال الـ token للباك اند للتحقق
  Future<void> _verifyQr(String token) async {

    if (_isProcessing || _scanned) return;

    setState(() {
      _isProcessing = true;
      _scanned = true;
    });

    await _scanner.stop();

    try {

      final response = await ApiClient.dio.post(
        '/reservations/verify-qr',
        queryParameters: {'token': token},
      );

      final data = response.data;

      if (!mounted) return;

      /// نجاح
      _showResult(
        success: true,
        title: 'Check-in Confirmed!',
        message:
        '${data['clientName']} — ${data['apartmentTitle']}\n'
            '${data['startDate']} → ${data['endDate']}',
      );

    } catch (e) {

      if (!mounted) return;

      String message = 'QR invalide ou déjà utilisé';

      try {
        final err = (e as dynamic).response?.data;
        if (err != null && err['message'] != null) {
          message = err['message'];
        }
      } catch (_) {}

      _showResult(
        success: false,
        title: 'Échec',
        message: message,
      );
    }
  }

  void _showResult({
    required bool success,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// أيقونة النتيجة
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: success
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.danger.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  success ? Icons.check_circle_outline : Icons.error_outline,
                  color: success ? AppColors.success : AppColors.danger,
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                title,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                message,
                style: AppTextStyles.muted,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Row(
                children: [

                  /// مسح آخر
                  if (success)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _scanned = false;
                            _isProcessing = false;
                          });
                          _scanner.start();
                        },
                        child: const Text('Scan again'),
                      ),
                    ),

                  if (success) const SizedBox(width: 12),

                  /// رجوع
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: success
                            ? AppColors.success
                            : AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _scanner.toggleTorch(),
            icon: const Icon(Icons.flashlight_on, color: Colors.white),
          ),
        ],
      ),

      body: Stack(
        children: [

          /// الكاميرا
          MobileScanner(
            controller: _scanner,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue != null) {
                _verifyQr(barcode!.rawValue!);
              }
            },
          ),

          /// إطار المسح
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          /// نص التوجيه
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'ضع كود QR العميل داخل الإطار',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          /// تحميل
          if (_isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}