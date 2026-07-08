import 'package:flutter/material.dart';
import '../../domain/entities/product_entities.dart';

class FeaturedProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onNavigate;
  final VoidCallback onFavorite;

  const FeaturedProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onNavigate,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-[24px]
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 30.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Top Image section with overlays
          Stack(
            children: [
              SizedBox(
                height: 200.0,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[200]),
                ),
              ),
              // Tag overlay top left
              Positioned(
                top: 16.0,
                left: 16.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: product.tag == 'Limited Edition'
                        ? const Color(0xFFBA1A1A)
                        : const Color(0xFF0058BE),
                    borderRadius: BorderRadius.circular(9999.0),
                  ),
                  child: Text(
                    product.tag.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Favorite Button top right
              Positioned(
                top: 16.0,
                right: 16.0,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(204), // 80% opacity
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: product.isFavorite
                          ? const Color(0xFFBA1A1A)
                          : const Color(0xFF6100D6),
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Detail column
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
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
                          const SizedBox(height: 2.0),
                          Text(
                            '${product.brandName} • ${product.floorText}',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6100D6), // primary
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0058BE), // secondary
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Button Actions (Navigate & View)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onNavigate,
                        child: Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF7B2FF7),
                                Color(0xFF2170E4),
                              ], // primary-gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.near_me,
                                color: Colors.white,
                                size: 16.0,
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                'Navigate',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: 48.0,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: const Color(0xFFCCC3D9),
                          ), // outline-variant
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4456), // on-surface-variant
                          ),
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
