import 'package:flutter/material.dart';
import '../../domain/entities/product_entities.dart';

class ProductBanner extends StatelessWidget {
  final ProductEntity product;

  const ProductBanner({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 442.0,
          width: double.infinity,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
          ),
        ),
        // Fading gradient bottom overlay
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black38,
                  Colors.transparent,
                  Color(0xFFFEF7FF), // background color fade
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
