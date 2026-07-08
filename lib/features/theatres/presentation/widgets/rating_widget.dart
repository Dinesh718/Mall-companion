import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final bool isLarge;

  const RatingWidget({super.key, required this.rating, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    if (isLarge) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F1FF), // surface-container-low
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color(
              0xFFCCC3D9,
            ).withOpacity(0.3), // outline-variant/30
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: Color(0xFF6100D6), // primary
              size: 20.0,
            ),
            const SizedBox(height: 2.0),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1A25), // on-surface
              ),
            ),
            const Text(
              'IMDb',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4456), // on-surface-variant
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(9999.0), // pill
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 12.0),
            const SizedBox(width: 4.0),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }
}
