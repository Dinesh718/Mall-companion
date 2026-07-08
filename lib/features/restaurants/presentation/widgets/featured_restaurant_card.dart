import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entities.dart';

class FeaturedRestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final VoidCallback onTap;

  const FeaturedRestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300.0,
        margin: const EdgeInsets.only(right: 16.0),
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Banner with Floating Rating
            Stack(
              children: [
                SizedBox(
                  height: 150.0,
                  width: double.infinity,
                  child: Image.network(
                    restaurant.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFEDE5F5),
                      child: const Icon(
                        Icons.restaurant_outlined,
                        color: Color(0xFF6100D6),
                        size: 32.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14.0,
                          color: Color(0xFF6100D6),
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Restaurant Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                                color: Color(0xFF1D1A25),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              '${restaurant.cuisine} • Floor ${restaurant.floorText.split(',').first}',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12.0,
                                color: Color(0xFF4A4456),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B2FF7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: const Text(
                          'PREMIUM',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 9.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6100D6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 16.0,
                        color: Color(0xFF813800), // tertiary
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'Waiting: ${restaurant.waitTimeText}',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF813800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
