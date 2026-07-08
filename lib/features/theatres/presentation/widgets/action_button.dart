import 'dart:ui';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isFav;
  final bool isTransparent;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isFav = false,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isTransparent
        ? const Color(0xFFFEF7FF).withOpacity(0.4)
        : const Color(0xFFFEF7FF).withOpacity(0.8);

    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          width: 48.0,
          height: 48.0,
          color: bgColor,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: Icon(
                  icon,
                  color: isFav ? const Color(0xFFBA1A1A) : const Color(0xFF1D1A25),
                  size: 24.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
