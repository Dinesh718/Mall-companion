import 'package:flutter/material.dart';
import '../../domain/entities/category_entities.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'apparel':
        return Icons.checkroom;
      case 'devices':
        return Icons.devices;
      case 'steps':
        return Icons.style;
      case 'face_retouching_natural':
        return Icons.face_retouching_natural;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'diamond':
        return Icons.diamond;
      case 'restaurant':
        return Icons.restaurant;
      case 'grid_view':
        return Icons.grid_view;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFEF7FF), // surface
          borderRadius: BorderRadius.circular(24.0), // rounded-[24px]
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image & Icon Overlay
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      category.bannerUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFEDE5F5),
                        child: const Icon(
                          Icons.image,
                          color: Color(0xFF7B7488),
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(color: Colors.black.withOpacity(0.1)),
                  ),
                  // Category Icon Box top-right
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _getIconData(category.iconName),
                        color: const Color(0xFF6100D6), // primary
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text Details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0, // card-title
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${category.storeCount} Stores',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0, // label-sm
                      color: Color(0xFF4A4456), // on-surface-variant
                    ),
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
