import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entities.dart';

class RestaurantReviewCard extends StatelessWidget {
  final RestaurantReviewEntity review;

  const RestaurantReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1FF), // surface-container-low
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE8DFEF).withOpacity(0.5),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Rating
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.network(
                  review.userAvatarUrl,
                  width: 36.0,
                  height: 36.0,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 36.0,
                    height: 36.0,
                    color: const Color(0xFFEDE5F5),
                    child: const Icon(Icons.person, color: Color(0xFF6100D6), size: 18.0),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      review.dateText,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10.0,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Row(
                children: [
                  const Icon(Icons.star, size: 14.0, color: Color(0xFFEAB308)),
                  const SizedBox(width: 2.0),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Content Paragraph
          Text(
            review.reviewText,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13.0,
              color: Color(0xFF4A4456),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
