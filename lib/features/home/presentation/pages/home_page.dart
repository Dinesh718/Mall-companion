import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_mall/features/map/presentation/pages/map_page.dart';

// Usecases & Data Layer
import '../../data/datasource/home_local_datasource.dart';
import '../../data/repository/home_repository_impl.dart';
import '../../domain/usecases/get_home_data.dart';

// BLoC
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

// Custom Widgets
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_home_header.dart';
import '../widgets/emergency_shortcut_card.dart';
import '../widgets/events_section.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/mall_card.dart';
import '../widgets/nearby_you_section.dart';
import '../widgets/offers_section.dart';
import '../widgets/parking_status_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/restaurants_section.dart';
import '../../../discover/presentation/pages/discover_page.dart';
import '../../../discover/presentation/pages/events/event_listing_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Instantiate repository and usecases directly (since there's no global DI container setup)
    return BlocProvider(
      create: (_) => HomeBloc(
        getHomeData: GetHomeData(
          HomeRepositoryImpl(localDataSource: HomeLocalDataSourceImpl()),
        ),
      )..add(const LoadHome()),
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF7FF), // surface / background
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _currentTabIndex,
            children: [
              // Tab 0: Home Dashboard
              const _HomeDashboardBody(),
              // Tab 1: Map
              const MapPage(),
              // Tab 2: Discover
              const DiscoverPage(),
              // Tab 3: Event
              const EventListingPage(),
              // Tab 4: Profile
              const ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentTabIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}

class _HomeDashboardBody extends StatelessWidget {
  const _HomeDashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
            ),
          );
        }

        if (state is HomeError) {
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
                  const Text(
                    'Failed to load Dashboard',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    state.errorMessage,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: Color(0xFF4A4456),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const LoadHome());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6100D6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is HomeLoaded) {
          final data = state.homeData;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshHome());
            },
            color: const Color(0xFF6100D6),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Custom Header Section
                  CustomHomeHeader(visitor: data.visitor, mall: data.mall),

                  // Section gaps defined as 32px or 24px in DESIGN.md
                  const SizedBox(height: 24.0),

                  // 2. Search Section
                  const HomeSearchBar(),
                  const SizedBox(height: 24.0),

                  // 3. Mall Map Preview Card Section
                  MallCard(mall: data.mall),
                  const SizedBox(height: 32.0), // Section padding spacing
                  // 4. Quick Actions Grid Section
                  QuickActionsGrid(actions: data.quickActions),
                  const SizedBox(height: 32.0),

                  // 5. Nearby You (Amenities) Section
                  NearbyYouSection(amenities: data.amenities),
                  const SizedBox(height: 32.0),

                  // 6. Today's Offers (Flash Deals) Section
                  OffersSection(offers: data.offers),
                  const SizedBox(height: 32.0),

                  // 7. Events & Activities Section
                  EventsSection(events: data.events),
                  const SizedBox(height: 32.0),

                  // 8. Popular Restaurants Section
                  RestaurantsSection(restaurants: data.restaurants),
                  const SizedBox(height: 32.0),

                  // 9. Parking Availability Section
                  ParkingStatusCard(levels: data.parkingLevels),
                  const SizedBox(height: 24.0),

                  // 10. Emergency Shortcuts Footer
                  EmergencyShortcutCard(emergency: data.emergency),

                  // Spacer to offset bottom navigation bar height (72px + padding)
                  const SizedBox(height: 120.0),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
