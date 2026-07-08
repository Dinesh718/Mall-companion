import 'package:flutter/material.dart';
import '../../domain/entities/parking_entities.dart';

class SavedVehicleCard extends StatelessWidget {
  final SavedVehicleEntity savedVehicle;
  final VoidCallback onNavigateTap;
  final VoidCallback onMapTap;
  final VoidCallback onClearTap;

  const SavedVehicleCard({
    super.key,
    required this.savedVehicle,
    required this.onNavigateTap,
    required this.onMapTap,
    required this.onClearTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6100D6), Color(0xFF2170E4)], // luxury-gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.0), // rounded-[28px]
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6100D6).withOpacity(0.25),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0), // p-6
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row details with vehicle status + slot information
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    child: const Text(
                      'Vehicle Saved',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0, // label-lg
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    '${savedVehicle.zone}, ${savedVehicle.row}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 24.0, // headline-lg-mobile
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${savedVehicle.floorText} • Slot ${savedVehicle.slot}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0, // body-md
                      color: Color(0xE6FFFFFF),
                    ),
                  ),
                ],
              ),
              // Car illustration mock placeholder (or generic vector icon)
              Icon(
                Icons.directions_car_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 64.0,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Saved time footer
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: Colors.white70,
                size: 16.0,
              ),
              const SizedBox(width: 6.0),
              Text(
                'Saved: ${savedVehicle.savedTime}',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.0, // label-md
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onNavigateTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6100D6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    elevation: 2.0,
                  ),
                  child: const Text(
                    'Navigate Now',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: OutlinedButton(
                  onPressed: onMapTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38, width: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'View Map',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          GestureDetector(
            onTap: onClearTap,
            child: const Align(
              alignment: Alignment.center,
              child: Text(
                'Clear Saved Location',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
