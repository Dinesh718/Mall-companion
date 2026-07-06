import 'package:flutter/material.dart';
import '../../domain/entities/discover_entities.dart';

class TrendingDining extends StatelessWidget {
  final List<DiscoverRestaurantEntity> restaurants;

  const TrendingDining({super.key, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & See All Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending Dining',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600, // headline-md
                  color: Color(0xFF1D1A25), // on-surface
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
                    fontWeight: FontWeight.w600, // label-lg
                    color: Color(0xFF6100D6), // primary
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // Vertical list of dining items
          ...restaurants.map((restaurant) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.all(12.0), // p-3
              decoration: BoxDecoration(
                color: const Color(0xFFF9F1FF), // surface-container-low
                borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                border: Border.all(
                  color: const Color(
                    0xFFCCC3D9,
                  ).withOpacity(0.2), // outline-variant/10
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Leading image
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0), // rounded-xl
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      restaurant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFEDE5F5),
                        child: const Icon(
                          Icons.restaurant_outlined,
                          size: 32.0,
                          color: Color(0xFF6100D6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Middle Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600, // label-lg
                                color: Color(0xFF1D1A25),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (restaurant.isOpen)
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4), // green-50
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 2.0,
                                ),
                                child: const Text(
                                  'Open',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500, // label-sm
                                    color: Color(0xFF16A34A), // green-600
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${restaurant.cuisine} • ${restaurant.floorText} • ⭐ ${restaurant.rating.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400, // body-md
                            color: Color(0xFF4A4456), // on-surface-variant
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        // Primary action / info footer
                        Text(
                          restaurant.waitTimeText.isNotEmpty
                              ? restaurant.waitTimeText
                              : restaurant.walkTimeText,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500, // label-sm
                            color: Color(0xFF6100D6), // primary
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Trailing Icon
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF7B7488), // outline
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
