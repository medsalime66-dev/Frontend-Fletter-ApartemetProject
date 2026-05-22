import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/reservation_model.dart';

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
//
  static Future<List<DateTime>>
  getUnavailableDates(
      int apartmentId,
      ) async {

    try {

      final response =
      await ApiClient.dio.get(

        '/reservations/unavailable-dates/$apartmentId',
      );

      final List data =
          response.data;

      return data.map((e) {

        return DateTime.parse(e);

      }).toList();

    } catch (e) {

      return [];
    }
  }
  /// my reservations
  static Future<List<Reservation>>
  getMyReservations() async {

    try {

      final response =
      await ApiClient.dio.get(
        '/reservations/my',
      );

      final List data =
          response.data;

      return data.map((e) {

        return Reservation.fromJson(e);

      }).toList();

    } on DioException catch (e) {

      throw Exception(

        e.response?.data['message']
            ?? 'Failed to load reservations',
      );

    } catch (_) {

      throw Exception(
        'Unexpected reservation error',
      );
    }
  }
}