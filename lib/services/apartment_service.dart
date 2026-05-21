import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

import '../models/apartment_model.dart';

class ApartmentService {

  final Dio _dio =
      ApiClient.dio;

  /// get approved apartments
  Future<List<ApartmentModel>>
  getApartments() async {

    try {

      final response =
      await _dio.get(
        '/apartments',
      );

      final List data =
          response.data;

      return data.map((json) {

        return ApartmentModel
            .fromJson(json);

      }).toList();

    } catch (e) {

      throw Exception(
        'Failed to load apartments',
      );
    }
  }

  /// get owner apartments
  Future<List<ApartmentModel>>
  getOwnerApartments() async {

    try {

      final response =
      await _dio.get(
        '/apartments/owner',
      );

      final List data =
          response.data;

      return data.map((json) {

        return ApartmentModel
            .fromJson(json);

      }).toList();

    } catch (e) {

      throw Exception(
        'Failed to load owner apartments',
      );
    }
  }

  /// get apartment details
  Future<ApartmentModel>
  getApartmentDetails(
      int apartmentId,
      ) async {

    try {

      final response =
      await _dio.get(
        '/apartments/$apartmentId',
      );

      return ApartmentModel
          .fromJson(
        response.data,
      );

    } catch (e) {

      throw Exception(
        'Failed to load apartment details',
      );
    }
  }

  /// create apartment
  Future<ApartmentModel>
  createApartment({

    required String title,

    required String description,

    required String city,

    required String district,

    required double pricePerNight,

    required String walletCode,

    required int rooms,

    required int bathrooms,

    required double area,

    required List<String> imageUrls,

  }) async {

    try {

      final response =
      await _dio.post(

        '/apartments',

        data: {

          'title': title,

          'description': description,

          'city': city,

          'district': district,

          'pricePerNight': pricePerNight,

          'walletCode': walletCode,

          'rooms': rooms,

          'bathrooms': bathrooms,

          'area': area,

          'imageUrls': imageUrls,
        },
      );

      return ApartmentModel
          .fromJson(
        response.data,
      );

    } catch (e) {

      throw Exception(
        'Failed to create apartment',
      );
    }
  }

  /// approve apartment
  Future<void> approveApartment(
      int apartmentId,
      ) async {

    try {

      await _dio.put(
        '/apartments/$apartmentId/approve',
      );

    } catch (e) {

      throw Exception(
        'Failed to approve apartment',
      );
    }
  }
}