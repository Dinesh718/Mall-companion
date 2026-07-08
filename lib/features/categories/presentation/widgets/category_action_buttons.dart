import 'package:flutter/material.dart';

class CategoryActionButtons extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback onFavoriteTap;
  final VoidCallback onShareTap;

  const CategoryActionButtons({
    super.key,
    required this.isFavorited,
    required this.onFavoriteTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Favorite Button
        GestureDetector(
          onTap: onFavoriteTap,
          child: Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE5F5), // bg-surface-container-high
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              isFavorited ? Icons.bookmark : Icons.bookmark_border,
              color: const Color(0xFF6100D6), // primary
              size: 20.0,
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        // Share Button
        GestureDetector(
          onTap: onShareTap,
          child: Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE5F5), // bg-surface-container-high
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.share_outlined,
              color: Color(0xFF6100D6), // primary
              size: 20.0,
            ),
          ),
        ),
      ],
    );
  }
}
