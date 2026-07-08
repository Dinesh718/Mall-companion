import 'package:flutter/material.dart';

class CategoryIconCard extends StatelessWidget {
  final String label;
  final String logoTextOrIcon;
  final VoidCallback? onTap;

  const CategoryIconCard({
    super.key,
    required this.label,
    required this.logoTextOrIcon,
    this.onTap,
  });

  IconData? _getBrandIcon(String name) {
    switch (name.toLowerCase()) {
      case 'shield':
        return Icons.shield;
      case 'diamond':
        return Icons.diamond;
      case 'apparel':
        return Icons.checkroom;
      case 'check_circle':
        return Icons.check_circle;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getBrandIcon(logoTextOrIcon);
    final isIcon = iconData != null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Logo Container
          Container(
            width: 80.0,
            height: 80.0,
            decoration: const BoxDecoration(
              color: Color(0xFFF3EBFA), // bg-surface-container
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: isIcon
                ? Icon(
                    iconData,
                    color: const Color(0xFF4A4456), // on-surface-variant
                    size: 32.0,
                  )
                : Text(
                    logoTextOrIcon,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                  ),
          ),
          const SizedBox(height: 8.0),
          // Brand/Category Label
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.0, // label-sm
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
        ],
      ),
    );
  }
}
