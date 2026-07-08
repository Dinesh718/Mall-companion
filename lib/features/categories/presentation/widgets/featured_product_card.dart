import 'package:flutter/material.dart';
import '../../domain/entities/category_entities.dart';

class FeaturedProductCard extends StatelessWidget {
  final CategoryProductEntity product;
  final VoidCallback onFavoriteTap;
  final VoidCallback onNavigateTap;

  const FeaturedProductCard({
    super.key,
    required this.product,
    required this.onFavoriteTap,
    required this.onNavigateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256.0, // w-64
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // bg-surface-container-lowest
        borderRadius: BorderRadius.circular(24.0), // rounded-3xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          SizedBox(
            height: 224.0, // h-56
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFEDE5F5),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: Color(0xFF7B7488),
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
                // Favorite Heart Button top right
                Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4.0,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite ? const Color(0xFFBA1A1A) : const Color(0xFF4A4456), // error or on-surface-variant
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Description details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16.0, // card-title
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  product.brandName,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
                const SizedBox(height: 16.0),
                // Price & Navigate Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6100D6), // primary
                      ),
                    ),
                    GestureDetector(
                      onTap: onNavigateTap,
                      child: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEDE5F5), // bg-surface-container-high
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.near_me,
                          color: Color(0xFF6100D6), // primary
                          size: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
