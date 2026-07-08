import 'package:flutter/material.dart';

class OfferBadge extends StatelessWidget {
  final String text;
  final bool
  isErrorColor; // true: Limited Edition (red), false: New Arrival / Offer (blue)

  const OfferBadge({super.key, required this.text, this.isErrorColor = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isErrorColor
            ? const Color(0xFFBA1A1A)
            : const Color(0xFF0058BE), // error : secondary
        borderRadius: BorderRadius.circular(9999.0), // pill
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
