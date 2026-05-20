import '../models/notification_model.dart';

final List<AppNotification> mockNotifications = [
  AppNotification(
    id: 1,
    title: 'Nouvelle réservation',
    message: 'Une nouvelle demande a été reçue.',
    createdAt: DateTime(2026, 5, 12),
    isRead: false,
  ),
  AppNotification(
    id: 2,
    title: 'Paiement reçu',
    message: 'Le paiement est en attente de validation.',
    createdAt: DateTime(2026, 5, 12),
    isRead: true,
  ),
];