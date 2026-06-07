import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import 'api_endpoints.dart';
import '../../screens/auth/login_page.dart';

class ApiClient {

  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: Duration(
        seconds: AppConstants.connectTimeout,
      ),
      receiveTimeout: Duration(
        seconds: AppConstants.receiveTimeout,
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<void> init() async {

    dio.interceptors.clear();

    dio.interceptors.add(

      InterceptorsWrapper(

        /// قبل كل طلب — إضافة الـ token
        onRequest: (options, handler) async {

          final prefs =
          await SharedPreferences.getInstance();

          final token =
          prefs.getString(AppConstants.tokenKey);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] =
            'Bearer $token';
          }

          handler.next(options);
        },

        /// عند النجاح
        onResponse: (response, handler) {
          handler.next(response);
        },

        /// عند الخطأ — 401 = token منتهي أو غير صالح
        onError: (error, handler) async {

          if (error.response?.statusCode == 401) {

            /// مسح كل البيانات المحفوظة
            final prefs =
            await SharedPreferences.getInstance();
            await prefs.clear();

            /// توجيه لصفحة Login مع إزالة كل الشاشات السابقة
            getx.Get.offAll(() => const LoginPage());

            /// إشعار للمستخدم
            getx.Get.snackbar(
              'Session expirée',
              'Veuillez vous reconnecter',
              snackPosition: getx.SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          }

          handler.next(error);
        },
      ),
    );
  }
}