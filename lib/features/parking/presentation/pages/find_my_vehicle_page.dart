import 'package:flutter/material.dart';
import '../../domain/entities/parking_entities.dart';

// Widgets
import '../widgets/login_benefits_card.dart';
import '../widgets/parking_history_card.dart';
import '../widgets/parking_map_card.dart';
import '../widgets/parking_timeline.dart';

class FindMyVehiclePage extends StatelessWidget {
  final SavedVehicleEntity savedVehicle;
  final List<ParkingHistoryItemEntity> history;
  final bool isLoggedIn;

  const FindMyVehiclePage({
    super.key,
    required this.savedVehicle,
    required this.history,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    // Standard walking timeline stages
    const timelineSteps = [
      ParkingTimelineStep(
        icon: Icons.location_on_rounded,
        description: 'Current Mall Position',
        isActive: true,
      ),
      ParkingTimelineStep(
        icon: Icons.stairs_rounded,
        description: 'Take Level 1 Escalator Down',
      ),
      ParkingTimelineStep(
        icon: Icons.elevator_rounded,
        description: 'Parking Elevator (B2)',
      ),
      ParkingTimelineStep(
        icon: Icons.directions_walk_rounded,
        description: 'Parking Corridor',
      ),
      ParkingTimelineStep(
        icon: Icons.directions_car_rounded,
        description: 'Vehicle in Zone B (Slot C-27)',
        isVehicle: true,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // bg-background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Custom Header
              _buildHeader(context),
              const SizedBox(height: 16.0),

              // 2. Saved Vehicle Hero card (Violet-Blue gradient layout)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildSavedVehicleHero(context),
              ),
              const SizedBox(height: 32.0),

              // 3. Route Map Preview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Route Preview',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20.0, // title-lg
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ParkingMapCard(
                      levelText: 'Route: Atrium -> Elevators -> Level B2',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),

              // 4. Indoor walking Navigation card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28.0),
                    border: Border.all(
                      color: const Color(0xFFE8DFEF).withOpacity(0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Walking Route',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 20.0, // headline-md
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D1A25),
                                ),
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                'Personalized indoor wayfinding',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12.0,
                                  color: Color(0xFF4A4456),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _buildWalkStat('3', 'Mins'),
                              const SizedBox(width: 16.0),
                              _buildWalkStat('240', 'Meters'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      // Timeline steps
                      const ParkingTimeline(steps: timelineSteps),
                      const SizedBox(height: 24.0),
                      // Action navigation CTA
                      SizedBox(
                        width: double.infinity,
                        height: 52.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.navigation_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Start Navigation',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),

              // 5. Navigation tools horizontal list
              _buildNavigationTools(),
              const SizedBox(height: 32.0),

              // 6. User Status Section (Promo vs History)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: isLoggedIn
                    ? _buildHistorySection(history)
                    : LoginBenefitsCard(onLoginTap: () {}),
              ),
              const SizedBox(height: 32.0),

              // 7. Emergency Support Assistance Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildEmergencySection(),
              ),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Find My Vehicle',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18.0, // headline-md
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6100D6),
                    ),
                  ),
                  Text(
                    'Navigate back to your parked vehicle',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11.0, // label-md
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: Color(0xFF4A4456),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFEDE5F5),
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedVehicleHero(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6100D6), Color(0xFF2170E4)], // luxury-gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.0), // rounded-[28px]
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    child: const Text(
                      'Vehicle Saved',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0, // label-lg
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    '${savedVehicle.zone}, ${savedVehicle.row}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 24.0, // headline-lg-mobile
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${savedVehicle.floorText} • Slot ${savedVehicle.slot}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0, // body-md
                      color: Color(0xE6FFFFFF),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.directions_car_rounded,
                color: Colors.white.withOpacity(0.95),
                size: 64.0,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: Colors.white70,
                size: 16.0,
              ),
              const SizedBox(width: 6.0),
              Text(
                'Saved Today, ${savedVehicle.savedTime}',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.0, // label-md
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6100D6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Navigate Now',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'View Map',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalkStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.0, // headline-md
            fontWeight: FontWeight.bold,
            color: Color(0xFF6100D6),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 11.0, // label-md
            color: Color(0xFF4A4456),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationTools() {
    final List<Map<String, dynamic>> tools = [
      {'name': 'BLE Tracking', 'icon': Icons.bluetooth},
      {'name': 'QR Navigation', 'icon': Icons.qr_code_scanner},
      {'name': 'Offline Nav', 'icon': Icons.signal_wifi_off},
      {'name': 'WiFi Positioning', 'icon': Icons.wifi},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Navigation Tools',
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
          height: 116.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return Container(
                width: 140.0,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F1FF), // surface-container-low
                  borderRadius: BorderRadius.circular(28.0),
                  border: Border.all(
                    color: const Color(0xFFE8DFEF).withOpacity(0.5),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tool['icon'] as IconData,
                      color: const Color(0xFF6100D6),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      tool['name'] as String,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0, // label-lg
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

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

  Widget _buildEmergencySection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6), // error-container
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: const Color(0xFFBA1A1A).withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need Help?',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // headline-md
              fontWeight: FontWeight.bold,
              color: Color(0xFF93000A), // on-error-container
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _buildEmergencyBtn(Icons.search_off, 'Lost Vehicle'),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildEmergencyBtn(Icons.phone_in_talk, 'Call Support'),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildEmergencyBtn(
                  Icons.admin_panel_settings,
                  'Locate Security',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyBtn(IconData icon, String label) {
    return Container(
      height: 72.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFBA1A1A)),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10.0, // label-md
              fontWeight: FontWeight.bold,
              color: Color(0xFF93000A),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
