import '../models/apartment_model.dart';
import '../services/apartment_service.dart';

class ApartmentRepository {

  final ApartmentService _service =
  ApartmentService();

  Future<List<ApartmentModel>>
  getApprovedApartments() async {

    try {

      return await _service.getApartments();

    } catch (e) {

      throw Exception(
        'Failed to load apartments',
      );
    }
  }

  /// جميع الشقق (بدون فلتر)
  Future<List<ApartmentModel>>
  getAllApartments() async {

    try {

      return await _service.getApartments();

    } catch (e) {

      throw Exception(
        'Failed to load apartments',
      );
    }
  }

  /// شقة بالـ id
  Future<ApartmentModel>
  getApartmentById(
      int apartmentId,
      ) async {

    try {

      return await _service
          .getApartmentDetails(apartmentId);

    } catch (e) {

      throw Exception(
        'Failed to load apartment',
      );
    }
  }

  /// شقق المالك
  Future<List<ApartmentModel>>
  getOwnerApartments() async {

    try {

      return await _service
          .getOwnerApartments();

    } catch (e) {

      throw Exception(
        'Failed to load owner apartments',
      );
    }
  }

  /// بحث محلي في القائمة الموجودة (بدون استدعاء API جديد)
  List<ApartmentModel> searchLocal(
      List<ApartmentModel> apartments,
      String query,
      ) {

    if (query.trim().isEmpty) {
      return apartments;
    }

    final lower = query.toLowerCase();

    return apartments.where((a) {

      return a.title
          .toLowerCase()
          .contains(lower) ||
          a.city
              .toLowerCase()
              .contains(lower) ||
          a.district
              .toLowerCase()
              .contains(lower);

    }).toList();
  }

  /// إنشاء شقة
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

      return await _service.createApartment(
        title: title,
        description: description,
        city: city,
        district: district,
        pricePerNight: pricePerNight,
        walletCode: walletCode,
        rooms: rooms,
        bathrooms: bathrooms,
        area: area,
        imageUrls: imageUrls,
      );

    } catch (e) {

      throw Exception(
        'Failed to create apartment',
      );
    }
  }

  /// قبول شقة
  Future<void> approveApartment(
      int apartmentId,
      ) async {

    try {

      await _service.approveApartment(
        apartmentId,
      );

    } catch (e) {

      throw Exception(
        'Failed to approve apartment',
      );
    }
  }

  /// تعديل شقة
  Future<ApartmentModel>
  updateApartment({
    required int id,
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

      return await _service.updateApartment(
        id: id,
        title: title,
        description: description,
        city: city,
        district: district,
        pricePerNight: pricePerNight,
        walletCode: walletCode,
        rooms: rooms,
        bathrooms: bathrooms,
        area: area,
        imageUrls: imageUrls,
      );

    } catch (e) {

      throw Exception(
        'Failed to update apartment',
      );
    }
  }

  /// حذف شقة
  Future<void> deleteApartment(
      int id,
      ) async {

    try {

      await _service.deleteApartment(
        id,
      );

    } catch (e) {

      throw Exception(
        'Failed to delete apartment',
      );
    }
  }
}