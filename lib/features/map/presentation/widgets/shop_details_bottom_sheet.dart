import 'package:flutter/material.dart';
import '../../domain/entities/map_entities.dart';

class ShopDetailsBottomSheet extends StatelessWidget {
  final ShopEntity shop;
  final String floorName;

  const ShopDetailsBottomSheet({
    super.key,
    required this.shop,
    required this.floorName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFEF7FF), // Surface background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: const Color(0xFF4A4456).withOpacity(0.4),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // Title & Favorite button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25), // On surface color
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          shop.category,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6100D6), // App primary color
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          width: 4.0,
                          height: 4.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4A4456),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          floorName,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0,
                            color: Color(
                              0xFF4A4456,
                            ), // On surface variant color
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFF6100D6),
                ),
                onPressed: () {
                  // UI only mock action
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Rating and Status info row
          Row(
            children: [
              // Rating Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16.0,
                      color: Color(0xFFFFB300),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      shop.rating.toString(),
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8F6300),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  shop.status.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Shop description
          Text(
            shop.description,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0,
              height: 1.5,
              color: Color(0xFF4A4456),
            ),
          ),
          const SizedBox(height: 20.0),

          // Active Offer banner
          if (shop.offer.isNotEmpty && shop.offer != 'No Active Offer')
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_outlined,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Special Offer Available',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          shop.offer,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0,
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
          const SizedBox(height: 24.0),

          // Action button row (visually active but functionally disabled)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.directions_outlined),
              label: const Text(
                'Navigate to Store',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6100D6),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onPressed: null, // Disabled navigation action
            ),
          ),
        ],
      ),
    );
  }
}
