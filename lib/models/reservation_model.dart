enum ReservationStatus {
  pending,
  confirmed,
  checkedIn,
  cancelled,
}

class Reservation {

  final int id;
  final int apartmentId;
  final String apartmentTitle;
  final String clientName;
  final String ownerName;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final ReservationStatus status;
  final String? qrToken;

  const Reservation({
    required this.id,
    required this.apartmentId,
    required this.apartmentTitle,
    required this.clientName,
    required this.ownerName,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    this.qrToken,
  });

  int get nights => endDate.difference(startDate).inDays;

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: _parseInt(json['reservationId'] ?? json['id']),
      apartmentId: _parseInt(json['apartmentId']),
      apartmentTitle: json['apartmentTitle'] ?? '',
      clientName: json['clientName'] ?? '',
      ownerName: json['ownerName'] ?? '',
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      totalPrice: _parseDouble(json['totalPrice']),
      status: _parseStatus(json['status']),
      qrToken: json['qrToken'],
    );
  }

  static ReservationStatus _parseStatus(dynamic value) {
    switch (value.toString().toUpperCase()) {
      case 'CONFIRMED':
        return ReservationStatus.confirmed;
      case 'CHECKED_IN':
        return ReservationStatus.checkedIn;
      case 'CANCELLED':
        return ReservationStatus.cancelled;
      default:
        return ReservationStatus.pending;
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static DateTime _parseDate(dynamic value) {
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apartmentId': apartmentId,
      'apartmentTitle': apartmentTitle,
      'clientName': clientName,
      'ownerName': ownerName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status.name.toUpperCase(),
      'qrToken': qrToken,
    };
  }
}