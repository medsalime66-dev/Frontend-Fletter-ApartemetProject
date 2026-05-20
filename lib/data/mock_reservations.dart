import '../models/reservation_model.dart';

final List<Reservation> mockReservations = [
  Reservation(
    id: 1,
    apartmentId: 1,
    apartmentTitle: 'Appartement Moderne',
    clientName: 'Mohamed',
    startDate: DateTime(2026, 6, 10),
    endDate: DateTime(2026, 6, 15),
    totalPrice: 6000,
    status: ReservationStatus.pending,
  ),
  Reservation(
    id: 2,
    apartmentId: 2,
    apartmentTitle: 'Suite Familiale',
    clientName: 'Ahmed',
    startDate: DateTime(2026, 6, 18),
    endDate: DateTime(2026, 6, 21),
    totalPrice: 5400,
    status: ReservationStatus.confirmed,
  ),
];