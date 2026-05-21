import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

class ReservationService {

  /// create reservation
  static Future<bool> createReservation({
    required int apartmentId,
    required String startDate,
    required String endDate,
  }) async {

    try {

      final response =
      await ApiClient.dio.post(

        '/reservations',

        data: {

          'apartmentId': apartmentId,
          'startDate': startDate,
          'endDate': endDate,
        },
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;

    } on DioException catch (e) {

      throw Exception(

        e.response?.data['message'] ??
            'Reservation failed',
      );

    } catch (e) {

      throw Exception(
        'Unexpected reservation error',
      );
    }
  }
}