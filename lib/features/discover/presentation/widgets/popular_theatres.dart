import 'package:flutter/material.dart';
import '../../domain/entities/discover_entities.dart';
import '../../../theatres/presentation/pages/theatre_details_page.dart';

class PopularTheatres extends StatelessWidget {
  final List<DiscoverTheatreEntity> theatres;

  const PopularTheatres({super.key, required this.theatres});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Popular Theatres',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.0,
              fontWeight: FontWeight.w600, // headline-md
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        // Horizontal list of movies
        SizedBox(
          height: 254.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: theatres.length,
            itemBuilder: (context, index) {
              final theatre = theatres[index];
              return GestureDetector(
                onTap: () {
                  String movieId = 'kingdom_planet_apes';
                  if (theatre.id.toLowerCase().contains('spiderman') ||
                      theatre.title.toLowerCase().contains('spiderman') ||
                      theatre.title.toLowerCase().contains('spider')) {
                    movieId = 'the_fall_guy';
                  } else if (theatre.id.toLowerCase().contains('avatar') ||
                      theatre.title.toLowerCase().contains('avatar')) {
                    movieId = 'furiosa';
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TheatreDetailsPage(movieId: movieId),
                    ),
                  );
                },
                child: Container(
                  width: 140.0,
                  margin: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie Poster Image
                      Container(
                        height: 180.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ), // rounded-xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          theatre.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
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
                      const SizedBox(height: 8.0),
                      // Movie title
                      Text(
                        theatre.title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1A25),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      // Cinema info
                      Text(
                        theatre.cinemaName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4A4456).withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
