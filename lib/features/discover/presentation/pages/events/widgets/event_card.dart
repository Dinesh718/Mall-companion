import 'package:flutter/material.dart';
import '../../../../domain/entities/discover_entities.dart';
import 'event_banner.dart';

enum EventCardType { hero, horizontal, vertical }

class EventCard extends StatelessWidget {
  final MallEventEntity event;
  final EventCardType type;
  final VoidCallback onTap;
  final VoidCallback? onDetailsTap;
  final VoidCallback? onNearMeTap;

  const EventCard({
    super.key,
    required this.event,
    required this.type,
    required this.onTap,
    this.onDetailsTap,
    this.onNearMeTap,
  });

  factory EventCard.hero({
    required MallEventEntity event,
    required VoidCallback onTap,
  }) {
    return EventCard(event: event, type: EventCardType.hero, onTap: onTap);
  }

  factory EventCard.horizontal({
    required MallEventEntity event,
    required VoidCallback onTap,
  }) {
    return EventCard(
      event: event,
      type: EventCardType.horizontal,
      onTap: onTap,
    );
  }

  factory EventCard.vertical({
    required MallEventEntity event,
    required VoidCallback onTap,
    required VoidCallback onDetailsTap,
    required VoidCallback onNearMeTap,
  }) {
    return EventCard(
      event: event,
      type: EventCardType.vertical,
      onTap: onTap,
      onDetailsTap: onDetailsTap,
      onNearMeTap: onNearMeTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case EventCardType.hero:
        return _buildHeroCard(context);
      case EventCardType.horizontal:
        return _buildHorizontalCard(context);
      case EventCardType.vertical:
        return _buildVerticalCard(context);
    }
  }

  // 1. Full-width Hero card display
  Widget _buildHeroCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 420.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0), // rounded-[32px]
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15.0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Banner Background
            EventBanner(
              imageUrl: event.imageUrl,
              statusText: event.statusText,
              categoryName: event.category,
              height: 420.0,
              borderRadius: 32.0,
            ),
            // Bottom Info overlays
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date & Time
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 14.0,
                          color: Color(0xFFD2BBFF), // primary-fixed-dim
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          '${event.dateText} • ${event.timeText.split(' - ').first}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600, // label-lg
                            color: Color(0xFFD2BBFF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    // Title
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26.0, // display-lg
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    // Venue
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14.0,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${event.venueName}, ${event.floorText}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0, // body-md
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 52.0,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7423F0), Color(0xFF3B82F6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                16.0,
                              ), // rounded-2xl
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16.0),
                              child: InkWell(
                                onTap: onTap,
                                borderRadius: BorderRadius.circular(16.0),
                                child: const Center(
                                  child: Text(
                                    'View Details',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600, // label-lg
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        GestureDetector(
                          onTap: onNearMeTap ?? () {},
                          child: Container(
                            width: 52.0,
                            height: 52.0,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                16.0,
                              ), // rounded-2xl
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.near_me_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Horizontal Card list item
  Widget _buildHorizontalCard(BuildContext context) {
    final endsInText = event.id == 'live_piano_session'
        ? 'Ends in 20m'
        : 'Daily 10-21';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260.0,
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0), // rounded-3xl (24px)
          border: Border.all(
            color: const Color(
              0xFFE8DFEF,
            ).withOpacity(0.5), // surface-variant/50
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15.0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12.0), // p-3
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Banner with relative overlays
            EventBanner(
              imageUrl: event.imageUrl,
              statusText: event.statusText,
              categoryName: event.category,
              height: 144.0,
              borderRadius: 16.0,
            ),
            const SizedBox(height: 12.0),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                event.name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600, // label-lg
                  color: Color(0xFF1D1A25), // on-surface
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6.0),
            // Details Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14.0,
                        color: Color(0xFF4A4456),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        event.venueName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0, // label-sm
                          color: Color(0xFF4A4456),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    endsInText,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      color: event.statusText.toLowerCase() == 'live'
                          ? const Color(0xFF6100D6) // primary
                          : const Color(0xFF4A4456),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Vertical Row item
  Widget _buildVerticalCard(BuildContext context) {
    final color = event.category.toLowerCase() == 'fashion'
        ? const Color(0xFF813800) // tertiary
        : const Color(0xFF6100D6); // primary

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-3xl
        border: Border.all(
          color: const Color(0xFFE8DFEF).withOpacity(0.3), // surface-variant/30
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15.0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0), // p-4
      child: Row(
        children: [
          // Image block
          GestureDetector(
            onTap: onTap,
            child: Container(
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
                    Icons.image_outlined,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          // Middle Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.category.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      event.dateText.split(', ').last,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.0,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  event.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600, // label-lg
                    color: Color(0xFF1D1A25),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  '${event.venueName}, ${event.floorText}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0, // label-sm
                    color: Color(0xFF4A4456),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12.0),
                // Action row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onDetailsTap,
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF9F1FF,
                            ), // surface-container-low
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: const Color(0xFF6100D6).withOpacity(0.1),
                              width: 1.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Details',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6100D6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: onNearMeTap,
                      child: Container(
                        width: 40.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFEDE5F5,
                          ), // surface-container-high
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.near_me_outlined,
                          size: 14.0,
                          color: Color(0xFF4A4456),
                        ),
                      ),
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
