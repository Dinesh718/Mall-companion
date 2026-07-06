import 'package:flutter/material.dart';
import '../../domain/entities/home_entities.dart';

class ParkingStatusCard extends StatelessWidget {
  final List<ParkingLevelEntity> levels;

  const ParkingStatusCard({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Parking Availability',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1A25),
                ),
              ),
              TextButton(
                onPressed: () {
                  // See all action
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(
                0xFFF9F1FF,
              ).withOpacity(0.5), // surface-container-low/50
              borderRadius: BorderRadius.circular(24.0), // rounded-3xl
              border: Border.all(
                color: const Color(0xFFCCC3D9).withOpacity(0.3),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: levels.map((level) {
                final isFull = level.isFull || level.availableSpots <= 0;
                final valueColor = isFull
                    ? const Color(0xFFBA1A1A)
                    : const Color(0xFF16A34A);
                final valueText = isFull ? 'Full' : '${level.availableSpots}';
                final captionText = isFull ? '0 Available' : 'Available';

                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        level.levelName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4A4456), // on-surface-variant
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        valueText,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: valueColor,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        captionText,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 8.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0x994A4456), // on-surface-variant/60
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
