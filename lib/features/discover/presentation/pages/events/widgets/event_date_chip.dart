import 'package:flutter/material.dart';

class EventDateChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const EventDateChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0), // rounded-full
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF7423F0), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected
              ? null
              : const Color(0xFFF9F1FF), // surface-container-low
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7423F0).withOpacity(0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0,
            fontWeight: FontWeight.w600, // label-lg
            color: isSelected
                ? Colors.white
                : const Color(0xFF4A4456), // text-white / on-surface-variant
          ),
        ),
      ),
    );
  }
}
