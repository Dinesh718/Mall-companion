import 'package:flutter/material.dart';

class AvailabilityChip extends StatelessWidget {
  final bool inStock;

  const AvailabilityChip({
    super.key,
    required this.inStock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: inStock
            ? const Color(0xFF7B2FF7).withAlpha(25) // primary-container/10
            : const Color(0xFFBA1A1A).withAlpha(25), // error/10
        borderRadius: BorderRadius.circular(8.0), // rounded-lg
      ),
      child: Text(
        inStock ? 'IN STOCK' : 'OUT OF STOCK',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
          color: inStock ? const Color(0xFF6100D6) : const Color(0xFFBA1A1A), // primary : error
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
