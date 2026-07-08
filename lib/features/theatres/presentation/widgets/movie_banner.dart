import 'package:flutter/material.dart';
import '../../domain/entities/theatre_entities.dart';
import 'booking_button.dart';

class MovieBanner extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onViewDetails;
  final VoidCallback onNavigate;

  const MovieBanner({
    super.key,
    required this.movie,
    required this.onViewDetails,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480.0,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0), // rounded-3xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFEDE5F5),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.movie,
                  size: 64.0,
                  color: Color(0xFF6100D6),
                ),
              ),
            ),
          ),

          // 2. Fading Black Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          // 3. Information Overlay (Bottom-aligned)
          Positioned(
            left: 24.0,
            right: 24.0,
            bottom: 24.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Tags
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        'IMDb ${movie.rating.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '• ${movie.genre} • ${movie.duration}',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500, // label-sm
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                // Title
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 28.0, // headline-lg-mobile
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8.0),

                // Location & Timing Details
                Row(
                  children: [
                    const Icon(
                      Icons.theater_comedy,
                      color: Colors.white70,
                      size: 18.0,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      movie.associatedTheatreName,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Text('•', style: TextStyle(color: Colors.white70)),
                    const SizedBox(width: 8.0),
                    const Text(
                      'Next: ',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      movie.nextShowTimeText,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEADDFF), // primary-fixed
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Actions buttons row
                Row(
                  children: [
                    Expanded(
                      child: BookingButton(
                        text: 'View Details',
                        onTap: onViewDetails,
                        height: 52.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    BookingButton(
                      text: 'Navigate',
                      icon: Icons.near_me,
                      onTap: onNavigate,
                      isSecondary: true,
                      height: 52.0,
                      width: 130.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
