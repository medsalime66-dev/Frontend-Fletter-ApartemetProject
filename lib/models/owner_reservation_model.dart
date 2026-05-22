class OwnerReservationModel {

  final int id;

  final String apartmentTitle;

  final String clientName;

  final String startDate;

  final String endDate;

  final double totalPrice;

  final String status;

  const OwnerReservationModel({

    required this.id,

    required this.apartmentTitle,

    required this.clientName,

    required this.startDate,

    required this.endDate,

    required this.totalPrice,

    required this.status,
  });

  factory OwnerReservationModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return OwnerReservationModel(

      id: json['reservationId'],

      apartmentTitle:
      json['apartmentTitle'] ?? '',

      clientName:
      json['clientName'] ?? '',

      startDate:
      json['startDate'] ?? '',

      endDate:
      json['endDate'] ?? '',

      totalPrice:
      (json['totalPrice'] ?? 0)
          .toDouble(),

      status:
      json['status'] ?? '',
    );
  }
}