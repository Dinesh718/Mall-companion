import 'package:flutter/material.dart';

class BookingButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSecondary;
  final IconData? icon;
  final double? width;
  final double height;

  const BookingButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSecondary = false,
    this.icon,
    this.width,
    this.height = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF3EBFA), // surface-container
          borderRadius: BorderRadius.circular(16.0), // rounded-2xl
          border: Border.all(
            color: const Color(
              0xFFCCC3D9,
            ).withOpacity(0.3), // outline-variant/30
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: const Color(0xFF6100D6), // primary
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6100D6), // primary text
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7423F0), Color(0xFF6100D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0), // rounded-2xl
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6100D6).withOpacity(0.2),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20.0),
                const SizedBox(width: 8.0),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
