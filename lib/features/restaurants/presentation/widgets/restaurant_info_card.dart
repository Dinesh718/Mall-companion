import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entities.dart';

class RestaurantInfoCard extends StatelessWidget {
  final RestaurantEntity restaurant;

  const RestaurantInfoCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Cuisine Row
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
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    restaurant.cuisine,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0,
                      color: Color(0xFF4A4456), // on-surface-variant
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3EBFA), // surface-container
                borderRadius: BorderRadius.circular(100.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 18.0,
                    color: Color(0xFFEAB308), // yellow-500
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    restaurant.rating.toStringAsFixed(1),
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
        const SizedBox(height: 16.0),

        // Metadata grid
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.layers,
                    size: 18.0,
                    color: Color(0xFF4A4456),
                  ),
                  const SizedBox(width: 6.0),
                  Expanded(
                    child: Text(
                      restaurant.floorText,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13.0,
                        color: Color(0xFF4A4456),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.call, size: 18.0, color: Color(0xFF4A4456)),
                  const SizedBox(width: 6.0),
                  Expanded(
                    child: Text(
                      restaurant.phone,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13.0,
                        color: Color(0xFF4A4456),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),

        // Description Paragraph
        Text(
          restaurant.description,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14.0,
            color: Color(0xFF4A4456),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
