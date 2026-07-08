import 'package:flutter/material.dart';

class CategoryInformationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;

  const CategoryInformationCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF), // surface
        borderRadius: BorderRadius.circular(16.0), // rounded-2xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE5F5), // surface-container-high
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              icon,
              color: iconColor ?? const Color(0xFF6100D6), // primary
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          // Text Contents
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
