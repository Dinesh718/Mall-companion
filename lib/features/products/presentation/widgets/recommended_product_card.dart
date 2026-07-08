import 'package:flutter/material.dart';
import '../../domain/entities/product_entities.dart';

class RecommendedProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool showBrandInfo;

  const RecommendedProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavorite,
    this.showBrandInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180.0,
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0), // rounded-2xl
          border: Border.all(
            color: const Color(0xFFCCC3D9).withAlpha(76), // outline-variant/30
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Favorite overlay
            Stack(
              children: [
                SizedBox(
                  height: 180.0,
                  width: double.infinity,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(204),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite ? const Color(0xFFBA1A1A) : const Color(0xFF4A4456),
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Text details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showBrandInfo) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.brandName.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6100D6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12.0),
                            const SizedBox(width: 2.0),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                  ],
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0058BE), // secondary
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
