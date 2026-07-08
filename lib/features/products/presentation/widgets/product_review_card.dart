import 'package:flutter/material.dart';
import '../../domain/entities/product_entities.dart';

class ProductReviewCard extends StatelessWidget {
  final ProductReviewEntity review;

  const ProductReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFCCC3D9).withAlpha(76), // outline-variant/30
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3EBFA), // surface-container
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1A25), // on-surface
                        ),
                      ),
                      Text(
                        review.date,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10.0,
                          color: Color(0xFF7B7488), // outline
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14.0),
                  const SizedBox(width: 4.0),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            review.comment,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.0,
              color: Color(0xFF4A4456), // on-surface-variant
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
