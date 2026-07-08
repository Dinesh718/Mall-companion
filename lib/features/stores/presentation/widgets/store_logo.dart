import 'package:flutter/material.dart';

class StoreLogo extends StatelessWidget {
  final String logoUrl;
  final double size;
  final double padding;

  const StoreLogo({
    super.key,
    required this.logoUrl,
    this.size = 48.0,
    this.padding = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.3), // outline-variant/30
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          logoUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFEDE5F5),
            alignment: Alignment.center,
            child: const Icon(
              Icons.store,
              color: Color(0xFF6100D6),
              size: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
