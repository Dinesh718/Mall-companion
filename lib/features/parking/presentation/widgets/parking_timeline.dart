import 'package:flutter/material.dart';

class ParkingTimelineStep {
  final IconData icon;
  final String description;
  final bool isActive;
  final bool isVehicle;

  const ParkingTimelineStep({
    required this.icon,
    required this.description,
    this.isActive = false,
    this.isVehicle = false,
  });
}

class ParkingTimeline extends StatelessWidget {
  final List<ParkingTimelineStep> steps;

  const ParkingTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vertical dotted or dashed line column
            Column(
              children: [
                Container(
                  width: 28.0,
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: step.isActive
                        ? const Color(0xFF6100D6) // primary
                        : step.isVehicle
                        ? const Color(0xFFD8E2FF) // secondary-fixed
                        : const Color(0xFFEDE5F5), // surface-container-high
                    shape: BoxShape.circle,
                    border: step.isActive
                        ? Border.all(
                            color: const Color(0xFFEADDFF),
                            width: 4.0,
                          ) // primary-fixed ring
                        : null,
                  ),
                  child: Icon(
                    step.icon,
                    size: 14.0,
                    color: step.isActive
                        ? Colors.white
                        : step.isVehicle
                        ? const Color(0xFF0058BE)
                        : const Color(0xFF4A4456),
                  ),
                ),
                if (!isLast)
                  // Custom dashed vertical line
                  Column(
                    children: List.generate(4, (i) {
                      return Container(
                        width: 2.0,
                        height: 6.0,
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        color: const Color(0xFFCCC3D9), // outline-variant
                      );
                    }),
                  ),
              ],
            ),
            const SizedBox(width: 16.0),
            // Text Column details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 20.0),
                child: Text(
                  step.description,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0, // body-lg
                    fontWeight: step.isActive || step.isVehicle
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: step.isActive || step.isVehicle
                        ? const Color(0xFF1D1A25) // on-surface
                        : const Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
