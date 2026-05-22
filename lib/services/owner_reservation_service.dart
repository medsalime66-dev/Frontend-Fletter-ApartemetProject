import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

import '../models/owner_reservation_model.dart';

class OwnerReservationService {

  static Future<
      List<OwnerReservationModel>>
  getReservations() async {

    try {

      final response =
      await ApiClient.dio.get(
        '/reservations/owner',
      );

      final List data =
          response.data;

      return data.map((json) {

        return OwnerReservationModel
            .fromJson(json);

      }).toList();

    } on DioException catch (_) {

      return [];

    } catch (_) {

      return [];
    }
  }
}