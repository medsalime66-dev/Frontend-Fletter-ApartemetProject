import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

import '../models/notification_model.dart';

class NotificationService {

  /// get notifications
  static Future<List<AppNotification>>
  getNotifications() async {

    try {

      final response =
      await ApiClient.dio.get(
        '/notifications',
      );

      final List data =
          response.data;

      return data.map((json) {

        return AppNotification
            .fromJson(json);

      }).toList();

    } on DioException catch (e) {

      throw Exception(

        e.response?.data['message'] ??
            'Failed to load notifications',
      );

    } catch (e) {

      throw Exception(
        'Unexpected notification error',
      );
    }
  }

  /// mark as read
  static Future<void> markAsRead(
      int id,
      ) async {

    try {

      await ApiClient.dio.put(
        '/notifications/$id/read',
      );

    } on DioException catch (e) {

      throw Exception(

        e.response?.data['message'] ??
            'Failed to mark notification as read',
      );

    } catch (e) {

      throw Exception(
        'Unexpected notification error',
      );
    }
  }
}