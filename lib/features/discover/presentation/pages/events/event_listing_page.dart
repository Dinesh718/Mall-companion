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
import 'widgets/event_card.dart';
import 'widgets/event_category_chip.dart';
import 'widgets/event_date_chip.dart';
import 'widgets/event_section_title.dart';
import 'event_details_page.dart';

class EventListingPage extends StatelessWidget {
  const EventListingPage({super.key});

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
      )..add(const LoadEvents()),
      child: const _EventListingBody(),
    );
  }
}

class _EventListingBody extends StatelessWidget {
  const _EventListingBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // bg-background
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<EventBloc, EventState>(
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
                        onPressed: () =>
                            context.read<EventBloc>().add(const LoadEvents()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is EventsLoaded) {
              final allEvents = state.events;
              final selectedCategory = state.selectedCategory;
              final selectedDateFilter = state.selectedDateFilter;

              // Filter logic for premium interactivity
              final filteredEvents = allEvents.where((e) {
                final catMatches =
                    selectedCategory == 'All' ||
                    e.category.toLowerCase() == selectedCategory.toLowerCase();

                bool dateMatches = true;
                if (selectedDateFilter == 'Today') {
                  dateMatches =
                      e.dateText.toLowerCase().contains('today') ||
                      e.statusText.toLowerCase() == 'live';
                } else if (selectedDateFilter == 'Tomorrow') {
                  dateMatches = e.dateText.toLowerCase().contains('tomorrow');
                } else if (selectedDateFilter == 'Weekend') {
                  dateMatches =
                      e.dateText.toLowerCase().contains('saturday') ||
                      e.dateText.toLowerCase().contains('sunday');
                }

                return catMatches && dateMatches;
              }).toList();

              // Separate events by status
              final featuredEvent = filteredEvents.firstWhere(
                (e) => e.statusText.toLowerCase() == 'featured',
                orElse: () => allEvents.first,
              );
              final happeningNow = filteredEvents
                  .where(
                    (e) =>
                        e.statusText.toLowerCase() == 'live' ||
                        e.statusText.toLowerCase() == 'ongoing',
                  )
                  .toList();
              final upcoming = filteredEvents
                  .where((e) => e.statusText.toLowerCase() == 'upcoming')
                  .toList();

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<EventBloc>().add(const RefreshEvents());
                },
                color: const Color(0xFF6100D6),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Custom Header
                      _buildHeader(context),
                      const SizedBox(height: 16.0),

                      // 2. Search & Floor/Date Filters
                      _buildSearchAndFilters(context, selectedDateFilter),
                      const SizedBox(height: 24.0),

                      // 3. Category Horizontal Filters
                      _buildCategoryFilters(context, selectedCategory),
                      const SizedBox(height: 32.0),

                      // 4. Featured Event Hero Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: EventCard.hero(
                          event: featuredEvent,
                          onTap: () =>
                              _navigateToDetails(context, featuredEvent.id),
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // 5. Happening Now Carousel
                      if (happeningNow.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: EventSectionTitle(
                            title: 'Happening Now',
                            actionText: 'View All',
                            onActionTap: () {},
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 228.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            itemCount: happeningNow.length,
                            itemBuilder: (context, index) {
                              final item = happeningNow[index];
                              return EventCard.horizontal(
                                event: item,
                                onTap: () =>
                                    _navigateToDetails(context, item.id),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],

                      // 6. Upcoming Events List
                      if (upcoming.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const EventSectionTitle(
                            title: 'Upcoming Events',
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: upcoming.map((item) {
                              return EventCard.vertical(
                                event: item,
                                onTap: () =>
                                    _navigateToDetails(context, item.id),
                                onDetailsTap: () =>
                                    _navigateToDetails(context, item.id),
                                onNearMeTap: () {},
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],

                      // 7. Weekend Highlights Banners
                      _buildWeekendHighlights(),

                      const SizedBox(height: 48.0),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Header Builder
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1D1A25),
            ),
            style: IconButton.styleFrom(
              backgroundColor: const Color(
                0xFFEDE5F5,
              ), // surface-container-high
              minimumSize: const Size(40.0, 40.0),
              shape: const CircleBorder(),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Events',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
                SizedBox(height: 1.0),
                Text(
                  'Discover exciting experiences',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0, // label-sm
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF6100D6),
            ),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFEDE5F5),
              shape: const CircleBorder(),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6100D6), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBHNbBKdyPMN-x3yO8vejkb967Ak-7IK4wY9igo7JAb0rEjxTcXy54phlBFlmtHslNosQ4OqG6sS9oO3KLloYBZN6chao9p_2MmAv8Yz219y_SPU2tbGWhKE0hjnDKM7qKxUeafmb5PDmfNsSMFoxPp75ZKFr5HWEXOpwFDdiGUf9lmeATBVP-hF7hbzwXYNwl1zu7oNig5EnyMNGY_s1sUpP4iehTFJXVooYFqeyTsRrfoyTP5urARr-gLZczA5-gRla3IVT3RlQ',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Search & Filters Builder
  Widget _buildSearchAndFilters(
    BuildContext context,
    String selectedDateFilter,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Search box
          Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: const [
                Icon(
                  Icons.search_outlined,
                  color: Color(0xFF7B7488),
                  size: 20.0,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search events, concerts, workshops...',
                      hintStyle: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF7B7488),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Icon(Icons.mic_outlined, color: Color(0xFF6100D6), size: 20.0),
                SizedBox(width: 12.0),
                Icon(
                  Icons.qr_code_scanner_outlined,
                  color: Color(0xFF6100D6),
                  size: 20.0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Dates chip list
          SizedBox(
            height: 38.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Floor Dropdown Simulator
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE5F5),
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      color: const Color(0xFFCCC3D9).withOpacity(0.3),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'All Floors',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 18.0),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: VerticalDivider(
                    color: Colors.black12,
                    thickness: 1.0,
                    width: 1.0,
                  ),
                ),
                ...['All', 'Today', 'Tomorrow', 'Weekend'].map((dateOpt) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: EventDateChip(
                      label: dateOpt,
                      isSelected: selectedDateFilter == dateOpt,
                      onTap: () {
                        context.read<EventBloc>().add(
                          FilterDateChanged(dateFilter: dateOpt),
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Category Filters Builder
  Widget _buildCategoryFilters(BuildContext context, String selectedCategory) {
    final List<Map<String, dynamic>> categoryOptions = [
      {'name': 'All', 'icon': Icons.grid_view},
      {'name': 'Music', 'icon': Icons.music_note},
      {'name': 'Fashion', 'icon': Icons.checkroom},
      {'name': 'Celebrity', 'icon': Icons.stars},
      {'name': 'Food', 'icon': Icons.restaurant},
      {'name': 'Art', 'icon': Icons.palette},
    ];

    return SizedBox(
      height: 84.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: categoryOptions.length,
        itemBuilder: (context, index) {
          final item = categoryOptions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: EventCategoryChip(
              categoryName: item['name'],
              iconData: item['icon'],
              isSelected: selectedCategory == item['name'],
              onTap: () {
                context.read<EventBloc>().add(
                  FilterCategoryChanged(category: item['name']),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Weekend Highlights Banners Builder
  Widget _buildWeekendHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: EventSectionTitle(title: 'Weekend Highlights'),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 160.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              // Banner 1: Summer Festival
              Container(
                width: 300.0,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7423F0), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Summer Festival',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.0, // headline-lg-mobile
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'Up to 40% off mall-wide',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0, // label-lg
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF7423F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Explore Deals',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Banner 2: Food Carnival
              Container(
                width: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: const Color(0xFF813800), // tertiary / brown
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 150.0,
                      child: Opacity(
                        opacity: 0.35,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(24.0),
                            bottomRight: Radius.circular(24.0),
                          ),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuD9cWdEMsdg9xyCIEyMEVIz3xyK4u--N2nu20frREl3MeVHvZUTjq64aq1UxA-6TX56yGCgUy7Jj_40XIsQlhG7I68HzhPOwXKVuW5n_R4nzlRC6G_7S7zOiYBWik7Wghxj8D3G9ofSIID2Zh5Y3qKdZ8O230GLdLt8H3Ex7_JBCFoPfd8SgsU74vGNvYbiGhl53WeXCLyVrlYg29Lv1jZLNPIu9EwZ4_5TtWOrGd48lT4SODqiNhpUKzT5hGDIIlrcoppmc2h4cg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Food Carnival',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          const Text(
                            'Taste the world at North Court',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF813800),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'View Menus',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Navigation Helper
  void _navigateToDetails(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailsPage(eventId: eventId)),
    );
  }
}
