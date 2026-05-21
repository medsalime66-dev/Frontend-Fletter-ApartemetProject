import '../models/apartment_model.dart';
import '../services/apartment_service.dart';

class ApartmentRepository{

//service
  final ApartmentService _service=
  ApartmentService();

//get approved apartments
  Future<List<ApartmentModel>>
  getApprovedApartments()async{

    try{

      final apartments=
      await _service.getApartments();

      return apartments.where((apartment){

        return apartment.status
            .toUpperCase()=='APPROVED';

      }).toList();

    }catch(e){

      throw Exception(
        'Failed to load apartments',
      );

    }
  }

//get all apartments
  Future<List<ApartmentModel>>
  getAllApartments()async{

    try{

      return await _service
          .getApartments();

    }catch(e){

      throw Exception(
        'Failed to load apartments',
      );

    }
  }

//get apartment by id
  Future<ApartmentModel>
  getApartmentById(
      int apartmentId,
      )async{

    try{

      return await _service
          .getApartmentDetails(
        apartmentId,
      );

    }catch(e){

      throw Exception(
        'Failed to load apartment',
      );

    }
  }

//get owner apartments
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

//search apartments
  Future<List<ApartmentModel>>
  searchApartments(
      String query,
      )async{

    try{

      final apartments=
      await getApprovedApartments();

      final lowerQuery=
      query.toLowerCase();

      return apartments.where((apartment){

        return apartment.title
            .toLowerCase()
            .contains(lowerQuery)

            ||

            apartment.city
                .toLowerCase()
                .contains(lowerQuery)

            ||

            apartment.district
                .toLowerCase()
                .contains(lowerQuery);

      }).toList();

    }catch(e){

      throw Exception(
        'Search failed',
      );

    }
  }

//create apartment
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
  })async{

    try{

      return await _service
          .createApartment(
        title:title,
        description:description,
        city:city,
        district:district,
        pricePerNight:pricePerNight,
        walletCode:walletCode,
        rooms:rooms,
        bathrooms:bathrooms,
        area:area,
        imageUrls:imageUrls,
      );

    }catch(e){

      throw Exception(
        'Failed to create apartment',
      );

    }
  }

//approve apartment
  Future<void>
  approveApartment(
      int apartmentId,
      )async{

    try{

      await _service
          .approveApartment(
        apartmentId,
      );

    }catch(e){

      throw Exception(
        'Failed to approve apartment',
      );

    }
  }
}