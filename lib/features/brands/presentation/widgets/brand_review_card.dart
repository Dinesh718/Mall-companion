import 'package:flutter/material.dart';
import '../../domain/entities/brand_entities.dart';

class BrandReviewCard extends StatelessWidget {
  final BrandReviewEntity review;

  const BrandReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE8DFEF).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.name,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1A25),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star_rounded,
                    color: index < review.rating.round()
                        ? const Color(0xFFFFB600)
                        : const Color(0xFFCCC3D9),
                    size: 16.0,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            review.reviewText,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13.0,
              color: Color(0xFF4A4456),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
