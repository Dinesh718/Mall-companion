import 'package:flutter/material.dart';
import '../../domain/entities/category_entities.dart';

class OfferCard extends StatelessWidget {
  final CategoryOfferEntity offer;
  final int index;
  final VoidCallback? onTap;

  const OfferCard({
    super.key,
    required this.offer,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Alternate styles based on the index to match the Stitch design
    final isEven = index % 2 == 0;

    final bgColor = isEven ? const Color(0xFFFFDBCA) : const Color(0xFFD8E2FF); // bg-tertiary-fixed or bg-secondary-fixed
    final textColor = isEven ? const Color(0xFF331200) : const Color(0xFF001A42); // on-tertiary-fixed or on-secondary-fixed
    final subtextColor = isEven ? const Color(0xFF763300) : const Color(0xFF004395); // on-tertiary-fixed-variant or on-secondary-fixed-variant
    final watermarkIcon = isEven ? Icons.percent : Icons.shopping_bag;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160.0, // h-40 = 10 * 16px
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.0), // rounded-3xl
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Watermark Icon
            Positioned(
              right: -32.0,
              bottom: -32.0,
              child: Transform.rotate(
                angle: 0.2, // 12 degrees approx
                child: Icon(
                  watermarkIcon,
                  size: 128.0,
                  color: Colors.black.withOpacity(0.05),
                ),
              ),
            ),
            // Text Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.tag.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: textColor.withOpacity(0.8),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      offer.title,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                Text(
                  offer.description,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: subtextColor,
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
