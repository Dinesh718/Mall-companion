import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Usecases & Repository
import '../../data/datasources/emergency_local_datasource.dart';
import '../../data/repositories/emergency_repository_impl.dart';
import '../../domain/usecases/emergency_usecases.dart';

// BLoC
import '../bloc/emergency_bloc.dart';
import '../bloc/emergency_event.dart';
import '../bloc/emergency_state.dart';

// Reusable Widgets
import '../widgets/emergency_hero_card.dart';
import '../widgets/emergency_shortcut_button.dart';
import '../widgets/emergency_action_grid.dart';
import '../widgets/emergency_facility_card.dart';
import '../widgets/emergency_timeline.dart';
import '../widgets/emergency_tips_card.dart';
import '../widgets/emergency_ui_states.dart';

// Pages
import 'emergency_navigation_page.dart';
import 'sos_security_page.dart';
import 'emergency_assistance_page.dart';

class EmergencyHubPage extends StatelessWidget {
  const EmergencyHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = EmergencyLocalDataSourceImpl();
    final repository = EmergencyRepositoryImpl(localDataSource: localDataSource);

    return BlocProvider(
      create: (_) => EmergencyBloc(
        loadEmergencyFacilitiesUseCase: LoadEmergencyFacilitiesUseCase(repository),
        loadEmergencyContactsUseCase: LoadEmergencyContactsUseCase(repository),
        startEmergencyNavigationUseCase: StartEmergencyNavigationUseCase(repository),
        sendSOSUseCase: SendSOSUseCase(repository),
        notifySecurityUseCase: NotifySecurityUseCase(repository),
        loadInstructionsUseCase: LoadInstructionsUseCase(repository),
      )..add(const LoadEmergencyHub()),
      child: const _EmergencyHubView(),
    );
  }
}

class _EmergencyHubView extends StatelessWidget {
  const _EmergencyHubView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // background
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.6),
        elevation: 0,
        scrolledUnderElevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1A25)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Mall Companion',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22.0, // display-md style
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1A25),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.contacts, color: Color(0xFF4A4456)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF4A4456)),
            onPressed: () {},
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: Stack(
        children: [
          // Blueprint lines background decoration
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(
                painter: _BlueprintGridPainter(),
              ),
            ),
          ),
          // Scrollable layout body
          BlocBuilder<EmergencyBloc, EmergencyState>(
            builder: (context, state) {
              if (state is EmergencyLoading || state is EmergencyInitial) {
                return const Center(
                  child: EmergencyLoadingSkeleton(),
                );
              }

              if (state is EmergencyError) {
                return Center(
                  child: EmergencyErrorState(
                    message: state.errorMessage,
                    onRetry: () {
                      context.read<EmergencyBloc>().add(const LoadEmergencyHub());
                    },
                  ),
                );
              }

              if (state is EmergencyLoaded) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome title header
                      const Text(
                      'Emergency',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28.0, // headline-lg-mobile
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                    ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Instant access to emergency services and assistance throughout the mall.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0, // body-md
                          color: Color(0xFF4A4456), // on-surface-variant
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // Emergency Hero Banner
                      EmergencyHeroCard(
                        title: 'Emergency Assistance',
                        description: 'Get immediate help with navigation, security, first aid and emergency services.',
                        badgeText: 'Mall Security Available 24/7',
                        primaryButtonText: 'Request Assistance',
                        secondaryButtonText: 'Emergency Navigation',
                        onPrimaryTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SOSSecurityPage(),
                            ),
                          );
                        },
                        onSecondaryTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmergencyNavigationPage(destination: 'Emergency Exit North'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32.0),
                      // Bento Grid
                      const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.0, // title-lg
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                    ),
                      const SizedBox(height: 16.0),
                      EmergencyActionGrid(
                        onSosTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SOSSecurityPage(),
                            ),
                          );
                        },
                        onSecurityDeskTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SOSSecurityPage(),
                            ),
                          );
                        },
                        onFireExitTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmergencyNavigationPage(destination: 'Fire Exit North'),
                            ),
                          );
                        },
                        onFirstAidTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmergencyNavigationPage(destination: 'First Aid Room'),
                            ),
                          );
                        },
                        onLostChildTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmergencyAssistancePage(),
                            ),
                          );
                        },
                        onHelpDeskTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmergencyAssistancePage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32.0),
                      // Priority Notice Section
                      _buildPriorityNoticeSection(),
                      const SizedBox(height: 32.0),
                      // Nearby facilities list (horizontal scroll)
                      const Text(
                      'Nearby Facilities',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 184.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.facilities.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 16.0),
                          itemBuilder: (context, index) {
                            final facility = state.facilities[index];
                            return EmergencyFacilityCard(
                              facility: facility,
                              onNavigateTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EmergencyNavigationPage(destination: facility.title),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      // Safety Instructions Card list
                      EmergencyTipsCard(
                        sectionTitle: 'Safety Info',
                        tips: const [
                          EmergencyTipItem(
                            text: 'Stay calm and follow instructions from mall staff.',
                            icon: Icons.psychology_outlined,
                          ),
                          EmergencyTipItem(
                            text: 'Do not use elevators during a fire emergency.',
                            icon: Icons.meeting_room_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 120.0), // spacer offset bottom nav
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          // Floating SOS button overlay (always available within one tap)
          Positioned(
            bottom: 96.0,
            right: 16.0,
            child: EmergencyShortcutButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SOSSecurityPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar matching spec tabs
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildPriorityNoticeSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF6100D6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.info, color: Color(0xFF6100D6), size: 20.0),
              ),
              const SizedBox(width: 12.0),
              const Text(
                'Priority Mode',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1A25),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          const Text(
            'In case of a major emergency, Priority Mode activates automatically across the app:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.0,
              color: Color(0xFF4A4456),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20.0),
          // Horizontal flow timeline
          const EmergencyTimeline(
            isHorizontal: true,
            steps: [
              EmergencyTimelineStep(
                title: 'Emergency Activated',
                description: '',
                icon: Icons.emergency,
                isActive: true,
              ),
              EmergencyTimelineStep(
                title: 'Normal UI Disabled',
                description: '',
                icon: Icons.block,
              ),
              EmergencyTimelineStep(
                title: 'Fastest Safe Route',
                description: '',
                icon: Icons.route,
              ),
              EmergencyTimelineStep(
                title: 'Security Notified',
                description: '',
                icon: Icons.notifications_active,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 72.0,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', false, () => Navigator.maybePop(context)),
          _buildNavItem(Icons.explore_outlined, 'Discover', false, null),
          _buildNavItem(Icons.local_parking_outlined, 'Parking', false, null),
          _buildNavItem(Icons.emergency, 'Emergency', true, null),
          _buildNavItem(Icons.person_outline, 'Profile', false, null),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback? onTap) {
    final activeColor = isActive ? const Color(0xFF6100D6) : const Color(0xFF4A4456);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: activeColor,
            size: 24.0,
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.0,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCC3D9).withOpacity(0.12)
      ..strokeWidth = 1.0;

    double gridSpacing = 32.0;

    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
