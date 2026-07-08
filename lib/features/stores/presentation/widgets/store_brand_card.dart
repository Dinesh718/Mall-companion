import 'package:flutter/material.dart';
import '../../domain/entities/store_entities.dart';

class StoreBrandCard extends StatelessWidget {
  final BrandEntity brand;

  const StoreBrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.0,
      height: 64.0,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFCCC3D9), // outline-variant
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        brand.name.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1D1A25), // on-surface
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
