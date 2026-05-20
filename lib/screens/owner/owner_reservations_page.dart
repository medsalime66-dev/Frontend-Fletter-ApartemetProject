import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_reservations.dart';
import '../../models/reservation_model.dart';
import '../../widgets/owner/owner_reservation_tile.dart';

class OwnerReservationsPage extends StatefulWidget {
  const OwnerReservationsPage({super.key});

  @override
  State<OwnerReservationsPage> createState() => _OwnerReservationsPageState();
}

class _OwnerReservationsPageState extends State<OwnerReservationsPage> {
  ReservationStatus? selectedStatus;

  List<Reservation> get filtered {
    if (selectedStatus == null) return mockReservations;

    return mockReservations.where((reservation) {
      return reservation.status == selectedStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservations', style: AppTextStyles.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          const Text(
            'Suivi des demandes',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 18),

          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'Toutes',
                  active: selectedStatus == null,
                  onTap: () {
                    setState(() {
                      selectedStatus = null;
                    });
                  },
                ),
                _FilterChip(
                  label: 'En attente',
                  active: selectedStatus == ReservationStatus.pending,
                  onTap: () {
                    setState(() {
                      selectedStatus = ReservationStatus.pending;
                    });
                  },
                ),
                _FilterChip(
                  label: 'Confirmées',
                  active: selectedStatus == ReservationStatus.confirmed,
                  onTap: () {
                    setState(() {
                      selectedStatus = ReservationStatus.confirmed;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          ...filtered.map(
                (reservation) {
              return OwnerReservationTile(
                apartment: reservation.apartmentTitle,
                client: reservation.clientName,
                status: reservation.status.name,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        selectedColor: AppColors.text,
        labelStyle: TextStyle(
          color: active ? Colors.white : AppColors.text,
          fontWeight: FontWeight.w700,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}