import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_mall/features/discover/data/datasource/discover_local_datasource.dart';
import 'package:visitor_mall/features/discover/data/repository/discover_repository_impl.dart';
import 'package:visitor_mall/features/discover/domain/usecases/get_events.dart';
import 'package:visitor_mall/features/discover/domain/usecases/register_for_event.dart';
import 'package:visitor_mall/features/discover/domain/usecases/toggle_bookmark_event.dart';

// BLoC
import 'bloc/event_bloc.dart';
import 'bloc/event_event.dart';
import 'bloc/event_state.dart';

// Usecases & Repositories

// Widgets
import 'widgets/event_action_buttons.dart';
import 'widgets/event_gallery.dart';
import 'widgets/event_host_card.dart';
import 'widgets/event_info_tile.dart';
import 'widgets/event_location_card.dart';
import 'widgets/event_participant_card.dart';
import 'widgets/event_schedule_card.dart';
import 'widgets/event_section_title.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final discoverRepo = DiscoverRepositoryImpl(
      localDataSource: DiscoverLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => EventBloc(
        getEvents: GetEvents(discoverRepo),
        toggleBookmarkEvent: ToggleBookmarkEvent(discoverRepo),
        registerForEvent: RegisterForEvent(discoverRepo),
      )..add(LoadEventDetails(eventId: eventId)),
      child: const _EventDetailsBody(),
    );
  }
}

class _EventDetailsBody extends StatefulWidget {
  const _EventDetailsBody();

  @override
  State<_EventDetailsBody> createState() => _EventDetailsBodyState();
}

class _EventDetailsBodyState extends State<_EventDetailsBody> {
  bool _aboutExpanded = false;

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // bg-background
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventInitial || state is EventLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
              ),
            );
          }

          if (state is EventError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64.0,
                      color: Color(0xFFBA1A1A),
                    ),
                    const SizedBox(height: 16.0),
                    Text(state.errorMessage),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is EventDetailsLoaded) {
            final event = state.event;

            return Stack(
              children: [
                // Scrollable details view
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Hero Image Section
                      Stack(
                        children: [
                          Image.network(
                            event.imageUrl,
                            height: viewportHeight * 0.45,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: viewportHeight * 0.45,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          // Live Indicator (Bottom Left of Hero)
                          if (event.statusText.toLowerCase() == 'live' ||
                              event.statusText.toLowerCase() == 'featured')
                            Positioned(
                              bottom: 48.0,
                              left: 20.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFBA1A1A), // red
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6.0,
                                      height: 6.0,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6.0),
                                    const Text(
                                      'LIVE NOW',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),

                      // 2. Info Overlapping Card Container
                      Transform.translate(
                        offset: const Offset(0, -32.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 20.0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.category.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6100D6),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  event.name,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 24.0, // headline-lg
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D1A25),
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                // Metadata Information grid
                                GridView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12.0,
                                        crossAxisSpacing: 12.0,
                                        childAspectRatio: 1.7,
                                      ),
                                  children: [
                                    EventInfoTile(
                                      iconData: Icons.calendar_today,
                                      label: 'Date',
                                      value: event.dateText,
                                    ),
                                    EventInfoTile(
                                      iconData: Icons.schedule,
                                      label: 'Time',
                                      value: event.timeText.split(' - ').first,
                                    ),
                                    EventInfoTile(
                                      iconData: Icons.location_on,
                                      label: 'Venue',
                                      value: event.venueName,
                                    ),
                                    EventInfoTile(
                                      iconData: Icons.layers,
                                      label: 'Floor',
                                      value: event.floorText,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 3. Participants row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: EventParticipantCard(
                          count: event.interestedCount,
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // 4. About Description Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const EventSectionTitle(title: 'About the Event'),
                            const SizedBox(height: 12.0),
                            Text(
                              event.description,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.0, // body-lg
                                color: Color(0xFF4A4456), // on-surface-variant
                                height: 1.5,
                              ),
                              maxLines: _aboutExpanded ? null : 3,
                              overflow: _aboutExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6.0),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _aboutExpanded = !_aboutExpanded;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _aboutExpanded ? 'Read Less' : 'Read More',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6100D6),
                                    ),
                                  ),
                                  Icon(
                                    _aboutExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: const Color(0xFF6100D6),
                                    size: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // 5. Host details card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const EventSectionTitle(title: 'Organizer'),
                            const SizedBox(height: 12.0),
                            EventHostCard(
                              hostName: event.organizerName,
                              hostLogoUrl: event.organizerLogoUrl,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // 6. Chronological Schedule timeline
                      if (event.schedule.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const EventSectionTitle(title: 'Schedule'),
                              const SizedBox(height: 16.0),
                              ...List.generate(event.schedule.length, (idx) {
                                final item = event.schedule[idx];
                                return EventScheduleCard(
                                  time: item.timeText,
                                  title: item.title,
                                  isLive: item.isLiveNow,
                                  isLast: idx == event.schedule.length - 1,
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],

                      // 7. Map location Layout card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const EventSectionTitle(title: 'Location map'),
                            const SizedBox(height: 12.0),
                            EventLocationCard(
                              venueName: event.venueName,
                              floorText: event.floorText,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // 8. Gallery / Sponsors Partners section
                      if (event.galleryUrls.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const EventSectionTitle(
                            title: 'Sponsors & Partners',
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        EventGallery(imageUrls: event.galleryUrls),
                        const SizedBox(height: 32.0),
                      ],

                      // Space offset for sticky floating buttons bar at bottom
                      const SizedBox(height: 160.0),
                    ],
                  ),
                ),

                // 2. Fixed Overlaid Top Actions Header (Back, share buttons)
                Positioned(
                  top: topPadding + 12.0,
                  left: 20.0,
                  right: 20.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<EventBloc>().add(
                                BookmarkEvent(eventId: event.id),
                              );
                            },
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                event.isBookmarked
                                    ? Icons.favorite
                                    : Icons.favorite_border_rounded,
                                color: event.isBookmarked
                                    ? Colors.red
                                    : Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          GestureDetector(
                            onTap: () {
                              context.read<EventBloc>().add(
                                BookmarkEvent(eventId: event.id),
                              );
                            },
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.share_rounded,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Sticky Bottom Glass Actions Bar overlay
                Positioned(
                  bottom: 24.0,
                  left: 20.0,
                  right: 20.0,
                  child: EventActionButtons(
                    isInterested: event.isBookmarked,
                    onNavigate: () {
                      // Navigate directions inside the mall
                    },
                    onInterested: () {
                      context.read<EventBloc>().add(
                        BookmarkEvent(eventId: event.id),
                      );
                    },
                    onShare: () {},
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
