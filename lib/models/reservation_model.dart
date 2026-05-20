enum ReservationStatus{
  pending,
  confirmed,
  cancelled,
}

class Reservation{
  final int id;
  final int apartmentId;
  final String apartmentTitle;
  final String clientName;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final ReservationStatus status;

  const Reservation({
    required this.id,
    required this.apartmentId,
    required this.apartmentTitle,
    required this.clientName,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
  });

  ///reservation nights
  int get nights{
    return endDate.difference(startDate).inDays;
  }

  ///json to object
  factory Reservation.fromJson(Map<String,dynamic> json){
    return Reservation(
      id:_parseInt(json['id']),
      apartmentId:_parseInt(json['apartmentId']),
      apartmentTitle:json['apartmentTitle']??'',
      clientName:json['clientName']??'',
      startDate:_parseDate(json['startDate']),
      endDate:_parseDate(json['endDate']),
      totalPrice:_parseDouble(json['totalPrice']),
      status:_parseStatus(json['status']),
    );
  }

  ///parse status
  static ReservationStatus _parseStatus(dynamic value){
    switch(value.toString().toUpperCase()){
      case 'CONFIRMED':
        return ReservationStatus.confirmed;

      case 'CANCELLED':
        return ReservationStatus.cancelled;

      default:
        return ReservationStatus.pending;
    }
  }

  ///parse int
  static int _parseInt(dynamic value){
    if(value is int){
      return value;
    }

    return int.tryParse(value.toString())??0;
  }

  ///parse double
  static double _parseDouble(dynamic value){
    if(value is double){
      return value;
    }

    if(value is int){
      return value.toDouble();
    }

    return double.tryParse(value.toString())??0;
  }

  ///parse date
  static DateTime _parseDate(dynamic value){
    try{
      return DateTime.parse(value.toString());
    }catch(_){
      return DateTime.now();
    }
  }

  ///object to json
  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'apartmentId':apartmentId,
      'apartmentTitle':apartmentTitle,
      'clientName':clientName,
      'startDate':startDate.toIso8601String(),
      'endDate':endDate.toIso8601String(),
      'totalPrice':totalPrice,
      'status':status.name.toUpperCase(),
    };
  }
}