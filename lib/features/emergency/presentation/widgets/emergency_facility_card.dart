import 'package:flutter/material.dart';
import '../../domain/entities/emergency_entities.dart';

class EmergencyFacilityCard extends StatelessWidget {
  final EmergencyFacilityEntity facility;
  final VoidCallback onNavigateTap;

  const EmergencyFacilityCard({
    super.key,
    required this.facility,
    required this.onNavigateTap,
  });

  @override
  Widget build(BuildContext context) {
    // Icon mapping
    IconData icon = Icons.help_outline;
    Color iconColor = const Color(0xFF6100D6);
    Color circleColor = const Color(0xFFEFF4FF);

    if (facility.iconName == 'exit_to_app') {
      icon = Icons.exit_to_app;
      iconColor = const Color(0xFFEA580C);
      circleColor = const Color(0xFFFFEDD5);
    } else if (facility.iconName == 'medical_services') {
      icon = Icons.medical_services;
      iconColor = const Color(0xFF16A34A);
      circleColor = const Color(0xFFDCFCE7);
    } else if (facility.iconName == 'security') {
      icon = Icons.security;
      iconColor = const Color(0xFF2563EB);
      circleColor = const Color(0xFFDBEAFE);
    }

    return Container(
      width: 280.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-24
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 20.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0, // title-md
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25), // on-surface
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      facility.location,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.0, // label-sm
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.straighten,
                    color: Color(0xFF4A4456),
                    size: 14.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${facility.distanceMeter.toInt()}m',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    color: Color(0xFF4A4456),
                    size: 14.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${facility.walkingTimeMinutes} min',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: onNavigateTap,
            child: Container(
              width: double.infinity,
              height: 40.0,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF), // surface-container-low
                borderRadius: BorderRadius.circular(12.0),
              ),
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions,
                    color: Color(0xFF6100D6),
                    size: 16.0,
                  ), // primary
                  SizedBox(width: 6.0),
                  Text(
                    'Navigate',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6100D6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
