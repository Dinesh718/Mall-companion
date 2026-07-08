import 'package:flutter/material.dart';
import '../../domain/entities/theatre_entities.dart';
import 'rating_widget.dart';

class MovieInfoCard extends StatelessWidget {
  final MovieEntity movie;

  const MovieInfoCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingWidget(rating: movie.rating, isLarge: true),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              movie.synopsis,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14.0, // body-md
                height: 1.5,
                color: Color(0xFF4A4456), // on-surface-variant
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
