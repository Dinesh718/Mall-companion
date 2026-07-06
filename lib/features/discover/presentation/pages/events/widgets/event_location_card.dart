import 'package:flutter/material.dart';

class EventLocationCard extends StatelessWidget {
  final String venueName;
  final String floorText;

  const EventLocationCard({
    super.key,
    required this.venueName,
    required this.floorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-3xl
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.2), // outline-variant/20
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulated map background preview
          Container(
            height: 120.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: const Color(0xFFF9F1FF), // surface-container-low
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Minimal map-like lines pattern using standard canvas or icons
                Opacity(
                  opacity: 0.15,
                  child: Icon(
                    Icons.map_outlined,
                    size: 80.0,
                    color: const Color(0xFF6100D6).withOpacity(0.8),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.my_location_rounded,
                        color: Color(0xFF6100D6),
                        size: 16.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        venueName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1A25),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Location text details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location Venue',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0, // label-sm
                      color: Color(0xFF7B7488), // outline
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    venueName,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE5F5), // surface-container-high
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                child: Text(
                  floorText,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
