import 'package:flutter/material.dart';

class BrandSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllTap;

  const BrandSectionTitle({super.key, required this.title, this.onViewAllTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1A25),
          ),
        ),
        if (onViewAllTap != null)
          GestureDetector(
            onTap: onViewAllTap,
            child: const Text(
              'View All',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6100D6),
              ),
            ),
          ),
      ],
    );
  }
}
