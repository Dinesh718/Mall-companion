import 'package:flutter/material.dart';
import '../../domain/entities/brand_entities.dart';

class BrandStoryCard extends StatelessWidget {
  final BrandEntity brand;

  const BrandStoryCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              brand.category,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6100D6),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              width: 4.0,
              height: 4.0,
              decoration: const BoxDecoration(
                color: Color(0xFF7B7488),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              brand.originCountry,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14.0,
                color: Color(0xFF7B7488),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Text(
          brand.description,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14.0,
            color: Color(0xFF4A4456),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16.0),
        // Information Grid Specs
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F1FF),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFE8DFEF).withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'FOUNDED',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B7488),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    brand.foundedYear,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                ],
              ),
              Container(
                width: 1.0,
                height: 32.0,
                color: const Color(0xFFCCC3D9),
              ),
              Column(
                children: [
                  const Text(
                    'WEBSITE',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B7488),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    brand.websiteUrl,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6100D6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
