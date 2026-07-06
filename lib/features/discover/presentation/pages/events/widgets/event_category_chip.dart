import 'package:flutter/material.dart';

class EventCategoryChip extends StatelessWidget {
  final String categoryName;
  final IconData iconData;
  final bool isSelected;
  final VoidCallback onTap;

  const EventCategoryChip({
    super.key,
    required this.categoryName,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFEADDFF) // primary-fixed
                  : const Color(0xFFEDE5F5), // surface-container-high
              borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Icon(
              iconData,
              size: 28.0,
              color: isSelected
                  ? const Color(0xFF6100D6) // primary
                  : const Color(0xFF4A4456), // on-surface-variant
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            categoryName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.0,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.w500, // label-sm
              color: isSelected
                  ? const Color(0xFF6100D6)
                  : const Color(0xFF1D1A25), // on-surface
            ),
          ),
        ],
      ),
    );
  }
}
