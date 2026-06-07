import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/apartment_model.dart';

class FavoritesController extends GetxController {

  final favorites = <ApartmentModel>[].obs;

  static const String _key = 'favorites';

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// تحميل المفضلة من الذاكرة
  Future<void> loadFavorites() async {

    final prefs =
    await SharedPreferences.getInstance();

    final data = prefs.getString(_key);

    if (data == null) return;

    final List decoded = jsonDecode(data);

    favorites.assignAll(
      decoded.map(
            (e) => ApartmentModel.fromJson(e),
      ),
    );
  }

  /// حفظ المفضلة في الذاكرة
  Future<void> _save() async {

    final prefs =
    await SharedPreferences.getInstance();

    final data = jsonEncode(
      favorites.map((a) => a.toJson()).toList(),
    );

    await prefs.setString(_key, data);
  }

  /// هل الشقة في المفضلة؟
  bool isFavorite(int apartmentId) {
    return favorites.any((a) => a.id == apartmentId);
  }

  /// إضافة أو إزالة من المفضلة
  Future<void> toggle(ApartmentModel apartment) async {

    if (isFavorite(apartment.id)) {

      favorites.removeWhere(
            (a) => a.id == apartment.id,
      );

      Get.snackbar(
        'Removed',
        'Removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
      );

    } else {

      favorites.add(apartment);

      Get.snackbar(
        'Added',
        'Added to favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    await _save();
  }

  /// مسح كل المفضلة
  Future<void> clearAll() async {
    favorites.clear();
    await _save();
  }
}