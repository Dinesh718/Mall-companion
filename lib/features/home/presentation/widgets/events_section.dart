import 'package:flutter/material.dart';
import '../../domain/entities/home_entities.dart';

class EventsSection extends StatelessWidget {
  final List<EventEntity> events;

  const EventsSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Events & Activities',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1A25),
                ),
              ),
              TextButton(
                onPressed: () {
                  // See all action
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          ...events.map((event) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0), // rounded-3xl
                border: Border.all(
                  color: const Color(0xFFCCC3D9).withOpacity(0.2),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20.0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Event Image
                  Container(
                    width: 96.0,
                    height: 96.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFEDE5F5),
                        child: const Icon(
                          Icons.event_outlined,
                          size: 32.0,
                          color: Color(0xFF6100D6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Event details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D1A25),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          event.subtitle,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF4A4456), // on-surface-variant
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${event.dateText} • ${event.locationText}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0x994A4456), // on-surface-variant/60
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
