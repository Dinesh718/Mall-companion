import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entities.dart';
import 'restaurant_banner.dart';
import 'restaurant_waiting_time_chip.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final VoidCallback onTap;
  final VoidCallback onNavigate;
  final VoidCallback onReserve;
  final VoidCallback onFavorite;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    required this.onNavigate,
    required this.onReserve,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15.0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFE8DFEF).withOpacity(0.5),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            RestaurantBanner(
              imageUrl: restaurant.imageUrl,
              rating: restaurant.rating,
              isOpen: restaurant.isOpen,
              height: 140.0,
              borderRadius: 16.0,
            ),
            const SizedBox(height: 12.0),

            // Middle Text Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25), // on-surface
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          '${restaurant.cuisine} • ${restaurant.floorText} • ${restaurant.priceRange}',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            color: Color(0xFF4A4456), // on-surface-variant
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Waiting Time Chip
                  RestaurantWaitingTimeChip(waitTimeText: restaurant.waitTimeText),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Action Buttons Footer
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onNavigate,
                    icon: const Icon(Icons.near_me, size: 16.0),
                    label: const Text('Navigate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3EBFA), // surface-container
                      foregroundColor: const Color(0xFF6100D6), // primary
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                      minimumSize: const Size(0, 40.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReserve,
                    icon: const Icon(Icons.event_seat, size: 16.0),
                    label: const Text('Reserve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6100D6), // primary
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                      minimumSize: const Size(0, 40.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // Favorite Button
                GestureDetector(
                  onTap: onFavorite,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3EBFA),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      restaurant.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: restaurant.isFavorite ? const Color(0xFFBA1A1A) : const Color(0xFF6100D6),
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
