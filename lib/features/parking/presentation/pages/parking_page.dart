import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLoC
import '../bloc/parking_bloc.dart';
import '../bloc/parking_event.dart';
import '../bloc/parking_state.dart';

// Usecases & Repositories
import '../../data/datasources/parking_local_datasource.dart';
import '../../data/repositories/parking_repository_impl.dart';
import '../../domain/entities/parking_entities.dart';

// Widgets
import '../widgets/login_benefits_card.dart';
import '../widgets/parking_hero_card.dart';
import '../widgets/parking_history_card.dart';
import '../widgets/parking_map_card.dart';
import '../widgets/parking_tips_card.dart';
import '../widgets/parking_zone_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/saved_vehicle_card.dart';
import 'find_my_vehicle_page.dart';

class ParkingPage extends StatelessWidget {
  const ParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingBloc(
        repository: ParkingRepositoryImpl(
          localDataSource: ParkingLocalDataSourceImpl(),
        ),
      )..add(const LoadParking()),
      child: const _ParkingPageBody(),
    );
  }
}

class _ParkingPageBody extends StatelessWidget {
  const _ParkingPageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // bg-background
      body: SafeArea(
        child: BlocConsumer<ParkingBloc, ParkingState>(
          listener: (context, state) {
            if (state is ParkingLoaded && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: const Color(0xFF6100D6),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ParkingInitial || state is ParkingLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
                ),
              );
            }

            if (state is ParkingError) {
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
                        onPressed: () => context.read<ParkingBloc>().add(
                          const LoadParking(),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ParkingLoaded) {
              final isVehicleSaved = state.savedVehicle != null;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ParkingBloc>().add(const RefreshParking());
                },
                color: const Color(0xFF6100D6),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Custom Header
                      _buildHeader(context, state.isLoggedIn),
                      const SizedBox(height: 16.0),

                      // 2. Main Title Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Parking',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 32.0, // display-lg-mobile
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D1A25), // on-surface
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              isVehicleSaved
                                  ? 'Find and navigate back to your parked car.'
                                  : 'Park smarter. Never lose your vehicle again.',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16.0, // body-lg
                                color: Color(0xFF4A4456), // on-surface-variant
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // 3. Hero Section (Saved Slot vs Availability Stats)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: state.savedVehicle != null
                            ? SavedVehicleCard(
                                savedVehicle: state.savedVehicle!,
                                onNavigateTap: () =>
                                    _navigateToFindVehicle(context, state),
                                onMapTap: () {},
                                onClearTap: () {
                                  context.read<ParkingBloc>().add(
                                    const RemoveSavedVehicle(),
                                  );
                                },
                              )
                            : ParkingHeroCard(availability: state.availability),
                      ),
                      const SizedBox(height: 24.0),

                      // 4. Quick Actions Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: QuickActionGrid(
                          onSaveTap: () {
                            const newLocation = SavedVehicleEntity(
                              zone: 'Zone B',
                              row: 'Row C',
                              slot: 'C-27',
                              level: 'Basement Level 2',
                              savedTime: '2:18 PM',
                              mallName: 'Grand Plaza Mall',
                              floorText: 'Basement Level 2',
                            );
                            context.read<ParkingBloc>().add(
                              const SaveVehicleLocation(location: newLocation),
                            );
                          },
                          onFindTap: () =>
                              _navigateToFindVehicle(context, state),
                          onMapTap: () {},
                          onZonesTap: () {},
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // 5. Zone Availability scroll list (only shown if vehicle is not saved)
                      if (!isVehicleSaved) ...[
                        _buildZoneAvailability(state.zones),
                        const SizedBox(height: 32.0),
                      ],

                      // 6. Map preview Section
                      _buildMapPreview(),
                      const SizedBox(height: 32.0),

                      // 7. Zone Amenities Section
                      _buildAmenitiesSection(),
                      const SizedBox(height: 32.0),

                      // 8. User Status Section (Guest Promo vs Logged In History)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: state.isLoggedIn
                            ? _buildHistorySection(state.history)
                            : LoginBenefitsCard(
                                onLoginTap: () {
                                  context.read<ParkingBloc>().add(
                                    const ToggleLoginState(),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 32.0),

                      // 9. Tips & Precision indicators
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: ParkingTipsCard(
                          tipText:
                              'Tap "Save Location" as soon as you park. Our high-precision beacons will pin your floor and zone automatically.',
                        ),
                      ),
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
  Widget _buildHeader(BuildContext context, bool isLoggedIn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF6100D6),
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
              const Text(
                'Mall Companion',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 18.0, // headline-md
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6100D6),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Tester Login toggle simulator
              TextButton(
                onPressed: () {
                  context.read<ParkingBloc>().add(const ToggleLoginState());
                },
                child: Text(
                  isLoggedIn ? 'Guest View' : 'Login View',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
              const SizedBox(width: 4.0),
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6100D6),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuD0vSMSf5tZDbmiClkR_AlLnK2P8m5MPnRf92hOgIbhwKntUx95t0Cvus3E6jnf_ey5PH9v-GVdNRS4WD2xfLgh63x1PpTJauNmkLg_G-9LdWPC9kH1ooHr1B1ioOW0_3W82-phyofk9jBG6pUwJRHHo1Vg7TtLWqb7_3KdLjls6c0vBLHJ9b4KBnMPvuKI6PfI15SiCfyTfICaoAB7qOdgReJYth2J87g70LWCIYO4ckETRY_B8y1iR-xkAncAoMcyKrEHgKawbHI',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Zone Availability Section
  Widget _buildZoneAvailability(List<ParkingZoneEntity> zones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Availability by Zone',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 144.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: zones.length,
            itemBuilder: (context, index) {
              return ParkingZoneCard(zone: zones[index]);
            },
          ),
        ),
      ],
    );
  }

  // Blueprint Map Section
  Widget _buildMapPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Parking Blueprint',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
            ),
          ),
          SizedBox(height: 16.0),
          ParkingMapCard(levelText: 'Viewing Level 2 - Central Wing'),
        ],
      ),
    );
  }

  // Amenities Section
  Widget _buildAmenitiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Zone Amenities',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildAmenityCard(
            Icons.ev_station_rounded,
            const Color(0xFF22C55E),
            const Color(0xFFDCFCE7),
            'Premium EV Charging',
            'Ultra-fast Tesla Superchargers and universal Type-2 ports available in Zone A.',
          ),
          const SizedBox(height: 12.0),
          _buildAmenityCard(
            Icons.elevator_rounded,
            const Color(0xFF0058BE),
            const Color(0xFFD8E2FF),
            'Main Atrium Access',
            'Zone B offers the shortest walking distance to luxury boutiques and dining.',
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityCard(
    IconData icon,
    Color iconColor,
    Color bgColor,
    String title,
    String description,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(color: const Color(0xFFE8DFEF).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13.0,
                    color: Color(0xFF4A4456),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // History List Builder
  Widget _buildHistorySection(List<ParkingHistoryItemEntity> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent History',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.0, // title-lg
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1A25),
          ),
        ),
        const SizedBox(height: 16.0),
        Column(
          children: history.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ParkingHistoryCard(item: item),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Navigations Helper
  void _navigateToFindVehicle(BuildContext context, ParkingLoaded state) {
    if (state.savedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please save your vehicle location first.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FindMyVehiclePage(
          savedVehicle: state.savedVehicle!,
          history: state.history,
          isLoggedIn: state.isLoggedIn,
        ),
      ),
    );
  }
}
