import 'package:flutter/material.dart';
import '../../domain/entities/theatre_entities.dart';
import 'rating_widget.dart';

enum MovieCardType { carousel, list }

class MovieCard extends StatelessWidget {
  final MovieEntity movie;
  final MovieCardType type;
  final VoidCallback onTap;
  final VoidCallback? onNavigate;
  final String? activeShowtimeId;
  final Function(String)? onShowtimeTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.type,
    required this.onTap,
    this.onNavigate,
    this.activeShowtimeId,
    this.onShowtimeTap,
  });

  factory MovieCard.carousel({
    required MovieEntity movie,
    required VoidCallback onTap,
  }) {
    return MovieCard(movie: movie, type: MovieCardType.carousel, onTap: onTap);
  }

  factory MovieCard.list({
    required MovieEntity movie,
    required VoidCallback onTap,
    required VoidCallback onNavigate,
    String? activeShowtimeId,
    Function(String)? onShowtimeTap,
  }) {
    return MovieCard(
      movie: movie,
      type: MovieCardType.list,
      onTap: onTap,
      onNavigate: onNavigate,
      activeShowtimeId: activeShowtimeId,
      onShowtimeTap: onShowtimeTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (type == MovieCardType.carousel) {
      return _buildCarouselCard(context);
    }
    return _buildListCard(context);
  }

  Widget _buildCarouselCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.0,
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            Container(
              height: 240.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      movie.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFEDE5F5),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.movie_filter_outlined,
                          size: 40.0,
                          color: Color(0xFF6100D6),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: RatingWidget(rating: movie.rating),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            // Title
            Text(
              movie.title,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16.0, // card-title
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1A25), // on-surface
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2.0),
            // Genre
            Text(
              movie.genre,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.0, // label-sm
                fontWeight: FontWeight.w400,
                color: Color(0xFF4A4456), // on-surface-variant
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0, left: 20.0, right: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0), // rounded-[32px]
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.3), // outline-variant/30
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for Image and Top Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Poster image
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 110.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    movie.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFEDE5F5),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.movie_outlined,
                        size: 32.0,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // Right: Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Score row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16.0, // card-title
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1A25), // on-surface
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '${movie.rating.toStringAsFixed(1)} ★',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6100D6), // primary
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),

                    // Genre & specs
                    Text(
                      '${movie.genre} • ${movie.language} • ${movie.duration}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12.0),

                    // Horizontal badges (Dolby Atmos, Recliner Seats)
                    if (movie.showTimes.isNotEmpty) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF2170E4,
                                ).withOpacity(0.1), // secondary-container/10
                                border: Border.all(
                                  color: const Color(
                                    0xFF2170E4,
                                  ).withOpacity(0.2),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: const Text(
                                'Dolby Atmos',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2170E4), // secondary
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF813800,
                                ).withOpacity(0.1), // tertiary-container/10
                                border: Border.all(
                                  color: const Color(
                                    0xFF813800,
                                  ).withOpacity(0.2),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: const Text(
                                'Recliner Seats',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF813800), // tertiary
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Showtime and Action Buttons sections (Placed BELOW the image/details Row)
          if (movie.showTimes.isNotEmpty) ...[
            const SizedBox(height: 16.0),
            // Horizontal showtime chips taking full width below image
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: movie.showTimes.map((st) {
                  final isSelected = activeShowtimeId == st.id;
                  final activeBg = isSelected
                      ? const Color(0xFF7B2FF7) // primary-container
                      : const Color(0xFFF3EBFA); // surface-container
                  final activeFg = isSelected
                      ? const Color(0xFFEBDDFF) // on-primary-container
                      : const Color(0xFF4A4456); // on-surface-variant

                  return GestureDetector(
                    onTap: () {
                      if (onShowtimeTap != null) {
                        onShowtimeTap!(st.id);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: activeBg,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        st.time,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: activeFg,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          const SizedBox(height: 16.0),
          // Action buttons taking full width below showtimes
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F1FF), // surface-container-low
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(0xFF6100D6).withOpacity(0.1),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Details',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              GestureDetector(
                onTap: onNavigate,
                child: Container(
                  width: 52.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6100D6).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Icon(
                    Icons.near_me_outlined,
                    size: 20.0,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
