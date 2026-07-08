import 'package:flutter/material.dart';

class ShowtimeChip extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const ShowtimeChip({
    super.key,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6100D6)
              : const Color(0xFFEDE5F5), // surface-container-high
          borderRadius: BorderRadius.circular(16.0), // rounded-2xl
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6100D6).withOpacity(0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          time,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : const Color(0xFF1D1A25), // text-on-surface
          ),
        ),
      ),
    );
  }
}
