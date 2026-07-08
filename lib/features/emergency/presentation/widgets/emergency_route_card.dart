import 'package:flutter/material.dart';
import '../../domain/entities/emergency_entities.dart';

class EmergencyRouteCard extends StatelessWidget {
  final List<RouteStepEntity> steps;

  const EmergencyRouteCard({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step-by-Step Guidance',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 24.0),
          Stack(
            children: [
              // Vertical Connecting Line
              Positioned(
                left: 15.5,
                top: 16.0,
                bottom: 16.0,
                child: Container(
                  width: 1.0,
                  color: const Color(0xFFCCC3D9).withOpacity(0.5),
                ),
              ),
              // List items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  final isLast = index == steps.length - 1;
                  final isFirst = index == 0;

                  Color circleColor = const Color(0xFFEFF4FF);
                  Color iconColor = const Color(0xFF0B1C30);

                  if (isFirst) {
                    circleColor = const Color(0xFF0058BE); // secondary
                    iconColor = Colors.white;
                  } else if (isLast) {
                    circleColor = const Color(0xFF6100D6); // primary
                    iconColor = Colors.white;
                  }

                  // Icon mapper
                  IconData icon = Icons.help_outline;
                  if (step.iconName == 'location_on') {
                    icon = Icons.location_on;
                  } else if (step.iconName == 'straight') {
                    icon = Icons.arrow_upward;
                  } else if (step.iconName == 'stairs') {
                    icon = Icons.stairs;
                  } else if (step.iconName == 'meeting_room') {
                    icon = Icons.meeting_room;
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0.0 : 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: circleColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.0),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 14.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.0, // title-md
                                  fontWeight: isLast ? FontWeight.bold : FontWeight.w600,
                                  color: isLast ? const Color(0xFF6100D6) : const Color(0xFF0B1C30),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                step.description,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0, // body-md
                                  color: Color(0xFF4A4456), // on-surface-variant
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
