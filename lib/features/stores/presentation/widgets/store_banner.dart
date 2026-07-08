import 'package:flutter/material.dart';
import '../../domain/entities/store_entities.dart';

class StoreBanner extends StatelessWidget {
  final StoreEntity store;

  const StoreBanner({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 397.0,
          width: double.infinity,
          child: Image.network(
            store.bannerUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
          ),
        ),
        // Fading gradient bottom overlay
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black45,
                  Colors.transparent,
                  Color(0xFFFEF7FF), // background color fade
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // Title overlay at the bottom left of hero
        Positioned(
          left: 20.0,
          bottom: 24.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store.name.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 40.0, // display-lg
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4.0),
              const Text(
                'Official Flagship Store',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                  color: Color(0xE6FFFFFF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
