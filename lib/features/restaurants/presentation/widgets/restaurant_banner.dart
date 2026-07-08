import 'package:flutter/material.dart';

class RestaurantBanner extends StatelessWidget {
  final String imageUrl;
  final double rating;
  final bool isOpen;
  final double height;
  final double borderRadius;

  const RestaurantBanner({
    super.key,
    required this.imageUrl,
    required this.rating,
    required this.isOpen,
    this.height = 140.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          // Banner Image
          SizedBox(
            height: height,
            width: double.infinity,
            child: Image.network(
              imageUrl,
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
          // Top Left Status Badge (Open / Closed)
          Positioned(
            top: 12.0,
            left: 12.0,
            child: Container(
              decoration: BoxDecoration(
                color: isOpen
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFBA1A1A),
                borderRadius: BorderRadius.circular(100.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 3.0,
              ),
              child: Text(
                isOpen ? 'OPEN' : 'CLOSED',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          // Top Right Rating Chip
          Positioned(
            top: 12.0,
            right: 12.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 3.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    size: 14.0,
                    color: Color(0xFF6100D6), // primary
                  ),
                  const SizedBox(width: 2.0),
                  Text(
                    rating.toStringAsFixed(1),
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
    );
  }
}
