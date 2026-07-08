import 'package:flutter/material.dart';

class SubcategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const SubcategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999.0), // rounded-full
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFFEDE5F5), // bg-surface-container-high
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7B2FF7).withOpacity(0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasIcon) ...[
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF6100D6),
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF1D1A25), // on-surface
              ),
            ),
          ],
        ),
      ),
    );
  }
}
