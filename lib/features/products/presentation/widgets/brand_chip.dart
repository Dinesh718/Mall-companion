import 'package:flutter/material.dart';

class BrandChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const BrandChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FF7), Color(0xFF2170E4)], // primary-container -> secondary-container gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(9999.0), // pill
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FF7).withAlpha(51),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.0, // label-sm
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE5F5), // surface-container-high
          borderRadius: BorderRadius.circular(9999.0),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12.0, // label-sm
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A4456), // on-surface-variant
          ),
        ),
      ),
    );
  }
}
