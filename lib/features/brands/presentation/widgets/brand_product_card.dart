import 'package:flutter/material.dart';
import '../../domain/entities/brand_entities.dart';

class BrandProductCard extends StatelessWidget {
  final BrandProductEntity product;
  final VoidCallback? onTap;

  const BrandProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15.0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFE8DFEF).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Product image
            Container(
              width: 96.0,
              height: 96.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF3EBFA),
                borderRadius: BorderRadius.circular(16.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16.0),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.0,
                      color: Color(0xFF7B7488),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6100D6),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EBFA),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          product.levelText,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6100D6),
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
      ),
    );
  }
}
