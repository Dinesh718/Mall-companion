import 'package:flutter/material.dart';
import '../../domain/entities/theatre_entities.dart';

class TheatreCard extends StatelessWidget {
  final TheatreEntity theatre;
  final VoidCallback onTap;
  final VoidCallback onNavigate;

  const TheatreCard({
    super.key,
    required this.theatre,
    required this.onTap,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0), // rounded-3xl
          border: Border.all(
            color: const Color(0xFFCCC3D9).withOpacity(0.3), // outline-variant/30
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left: Map path avatar icon or generic movie/theatre icon
            Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF3EBFA), // surface-container
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Icon(
                Icons.movie_filter,
                color: Color(0xFF6100D6), // primary
                size: 28.0,
              ),
            ),
            const SizedBox(width: 16.0),

            // Middle: Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theatre.name,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${theatre.floorText} • ${theatre.distanceWalkText}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0,
                      color: Color(0xFF4A4456), // on-surface-variant
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),

            // Right: Navigation Icon
            IconButton(
              icon: const Icon(Icons.near_me_outlined),
              color: const Color(0xFF6100D6), // primary
              onPressed: onNavigate,
            ),
          ],
        ),
      ),
    );
  }
}
