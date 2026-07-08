import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entities.dart';

class RestaurantRatingCard extends StatelessWidget {
  final RestaurantEntity restaurant;

  const RestaurantRatingCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    // Generate guest counts and seating times dynamically based on wait time simulation
    final isDirectSeating = restaurant.waitTimeText.toLowerCase() == 'open';
    final waitMinutes = isDirectSeating ? 0 : int.tryParse(restaurant.waitTimeText.replaceAll(RegExp(r'[^0-9]'), '')) ?? 10;
    final guestCount = waitMinutes > 0 ? (waitMinutes * 1.2).round() : 0;

    // Calculate seating time
    final now = DateTime.now();
    final seatingTime = now.add(Duration(minutes: waitMinutes));
    final timeString = "${seatingTime.hour.toString().padLeft(2, '0')}:${seatingTime.minute.toString().padLeft(2, '0')} PM";

    return Container(
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
        border: Border.all(
          color: const Color(0xFFE8DFEF).withOpacity(0.5),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Live Indicator Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A34A), // Emerald green
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'LIVE STATUS',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const Text(
                'Updated 1 min ago',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11.0,
                  color: Color(0xFF4A4456),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Wait Time & In Queue grid
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F1FF), // surface-container-low
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wait Time',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11.0,
                          color: Color(0xFF4A4456),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: isDirectSeating ? '0' : waitMinutes.toString(),
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6100D6),
                              ),
                            ),
                            const TextSpan(
                              text: ' min',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13.0,
                                color: Color(0xFF4A4456),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F1FF),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'In Queue',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11.0,
                          color: Color(0xFF4A4456),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: guestCount.toString(),
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0058BE),
                              ),
                            ),
                            const TextSpan(
                              text: ' guests',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13.0,
                                color: Color(0xFF4A4456),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Seating Time calculation
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFEDE5F5), // outline-variant
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.event_seat, size: 20.0, color: Color(0xFF4A4456)),
                    SizedBox(width: 8.0),
                    Text(
                      'Est. Seating Time',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14.0,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                  ],
                ),
                Text(
                  isDirectSeating ? 'Immediate' : timeString,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
