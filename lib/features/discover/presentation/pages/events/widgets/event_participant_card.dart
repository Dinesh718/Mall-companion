import 'package:flutter/material.dart';

class EventParticipantCard extends StatelessWidget {
  final int count;

  const EventParticipantCard({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    // A list of static friendly profile avatars for mockup display
    final List<String> avatars = [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBHNbBKdyPMN-x3yO8vejkb967Ak-7IK4wY9igo7JAb0rEjxTcXy54phlBFlmtHslNosQ4OqG6sS9oO3KLloYBZN6chao9p_2MmAv8Yz219y_SPU2tbGWhKE0hjnDKM7qKxUeafmb5PDmfNsSMFoxPp75ZKFr5HWEXOpwFDdiGUf9lmeATBVP-hF7hbzwXYNwl1zu7oNig5EnyMNGY_s1sUpP4iehTFJXVooYFqeyTsRrfoyTP5urARr-gLZczA5-gRla3IVT3RlQ',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA-2wdVyLj7SmNFV8wPBqf-KyEW9A4BPapnZy2HYBjmY3HgS-6Gak730iqDsHMsjoqOPBxtRtvJj2ctclzUqladIW_EzT_w2YgbJv_gKmCr_oHjNs73JPtlABq8cOtREVHuStgmMMoPIW6okzuVKJE57slrepCbZqvNQr_xDqrzkDW1lhE4g5QCClyrQ2MY5SGNHBdGO-aOa5EBIdct_uYUlOBbcshmeczcMD6LVg8UJDtUB82XiecKwfy1Z4JfMfTTTXP2WoFaTw',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCqSBhqef5Wg_-t6nAcXLaxaxNs8DNHbFuAW8yjuwXyrqwBxCp8ohIod26_eI9OWyCTVvQzoZrG9CrraCOR1NDSW9rocZpfLwHWpRaKcFI-NGh4MzJGv9bjUvlN8ObJRWNecG9o-7E28tiIN3zNQkQXB7q1NGBBxfSqG1Vjq-d82yQuQUGH5MFfHsE6CiFbTKgupwiiIH46_66JtJ5j29b3y3wU5-M8tVSCNg3zifi1U8zLfdLy9UZDR-AcQ2z0GadIu10S589yng',
    ];

    return Row(
      children: [
        SizedBox(
          width: 72.0,
          height: 32.0,
          child: Stack(
            children: List.generate(avatars.length, (index) {
              return Positioned(
                left: index * 18.0,
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                    color: const Color(0xFFEADDFF),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network(
                      avatars[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 16.0,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          '+$count interested in this event',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.0,
            fontWeight: FontWeight.w600, // label-sm
            color: Color(0xFF4A4456), // on-surface-variant
          ),
        ),
      ],
    );
  }
}
