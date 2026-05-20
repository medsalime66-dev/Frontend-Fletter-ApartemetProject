class ApartmentModel{

  final int id;
  final String title;
  final String description;
  final String city;
  final String district;
  final double pricePerNight;
  final String walletCode;
  final int rooms;
  final int bathrooms;
  final double area;
  final List<String> imageUrls;
  final String status;
  final String ownerName;
  final String ownerPhone;

  ApartmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.district,
    required this.pricePerNight,
    required this.walletCode,
    required this.rooms,
    required this.bathrooms,
    required this.area,
    required this.imageUrls,
    required this.status,
    required this.ownerName,
    required this.ownerPhone,
  });

  factory ApartmentModel.fromJson(Map<String,dynamic> json){
    return ApartmentModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      pricePerNight: (json['pricePerNight'] ?? 0).toDouble(),
      walletCode: json['walletCode'] ?? '',
      rooms: json['rooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      area: (json['area'] ?? 0).toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      status: json['status'] ?? '',
      ownerName: json['ownerName'] ?? '',
      ownerPhone: json['ownerPhone'] ?? '',
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'title':title,
      'description':description,
      'city':city,
      'district':district,
      'pricePerNight':pricePerNight,
      'walletCode':walletCode,
      'rooms':rooms,
      'bathrooms':bathrooms,
      'area':area,
      'imageUrls':imageUrls,
      'status':status,
      'ownerName':ownerName,
      'ownerPhone':ownerPhone,
    };
  }
}