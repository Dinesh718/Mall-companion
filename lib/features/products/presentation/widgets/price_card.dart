import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;

  const PriceCard({
    super.key,
    required this.price,
    this.originalPrice,
    this.fontSize = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6100D6), // primary color
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 8.0),
          Text(
            '\$${originalPrice!.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: fontSize * 0.6,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7B7488), // outline
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}
