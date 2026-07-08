import 'package:flutter/material.dart';
import '../../domain/entities/parking_entities.dart';

class ParkingZoneCard extends StatelessWidget {
  final ParkingZoneEntity zone;

  const ParkingZoneCard({super.key, required this.zone});

  Color _getStatusColor() {
    switch (zone.status.toLowerCase()) {
      case 'available':
        return const Color(0xFF22C55E); // green-500
      case 'limited':
        return const Color(0xFFF97316); // orange-500
      case 'full':
        return const Color(0xFFEF4444); // red-500
      default:
        return const Color(0xFF6B7280); // gray-500
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final progress = zone.occupancyPercentage / 100.0;

    return Container(
      width: 172.0,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0), // rounded-xxl (28px)
        border: Border.all(
          color: const Color(0xFFE8DFEF).withOpacity(0.5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0), // p-5
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                zone.name,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20.0, // headline-md
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6100D6), // primary
                ),
              ),
              Text(
                zone.status,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.0, // label-lg
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Progress occupancy indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Occupancy',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11.0, // label-md
                      color: Color(0xFF4A4456), // on-surface-variant
                    ),
                  ),
                  Text(
                    '${zone.occupancyPercentage}%',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Container(
                height: 8.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE5F5), // surface-container-high
                  borderRadius: BorderRadius.circular(100.0),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Details Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${zone.availableSpaces} Spaces',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.0, // body-md
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A4456),
                ),
              ),
              if (zone.hasEVCharging)
                const Icon(
                  Icons.ev_station_rounded,
                  size: 16.0,
                  color: Color(0xFF22C55E),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
