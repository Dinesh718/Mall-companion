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
import '../widgets/emergency_facility_card.dart';
import '../widgets/emergency_timeline.dart';
import '../widgets/emergency_tips_card.dart';
import '../widgets/emergency_ui_states.dart';

// Pages
import 'emergency_navigation_page.dart';

class EmergencyAssistancePage extends StatelessWidget {
  const EmergencyAssistancePage({super.key});

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
      child: const _EmergencyAssistanceView(),
    );
  }
}

class _EmergencyAssistanceView extends StatelessWidget {
  const _EmergencyAssistanceView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
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
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1A25),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF1D1A25)),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<EmergencyBloc, EmergencyState>(
        builder: (context, state) {
          if (state is EmergencyLoading || state is EmergencyInitial) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
              ),
            );
          }

          if (state is EmergencyError) {
            return Center(
              child: EmergencyErrorState(message: state.errorMessage),
            );
          }

          if (state is EmergencyLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Assistance Center',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24.0, // headline-lg-mobile
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    'Quick support for visitors needing immediate assistance.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Hero Gradient Card
                  _buildHeroCard(),
                  const SizedBox(height: 24.0),
                  // Service Grid
                  _buildServiceCardsGrid(context),
                  const SizedBox(height: 32.0),
                  // Nearby Facilities list
                  const Text(
                    'Nearby Facilities',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
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
                  // How it works timeline process
                  _buildHowItWorksSection(),
                  const SizedBox(height: 32.0),
                  // Safety Guidelines & Tip Block
                  const EmergencyTipsCard(
                    sectionTitle: 'Safety Guidelines',
                    tips: [
                      EmergencyTipItem(
                        text: 'What to do in a fire emergency?',
                        icon: Icons.verified_user_outlined,
                      ),
                      EmergencyTipItem(
                        text: 'Personal safety best practices',
                        icon: Icons.security_outlined,
                      ),
                    ],
                    quickTipText: 'Stay calm and remain in a visible area while waiting for assistance. Security is always patrolling.',
                  ),
                  const SizedBox(height: 64.0),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 180.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)], // primary-gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -24.0,
            top: -24.0,
            child: Container(
              width: 160.0,
              height: 160.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned(
            right: 20.0,
            bottom: 20.0,
            child: Opacity(
              opacity: 0.25,
              child: Icon(
                Icons.shield_outlined,
                color: Colors.white,
                size: 120.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'How can we help you?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22.0, // title-lg
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  'Our dedicated team is ready to support you 24/7 during mall hours.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.0,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCardsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      childAspectRatio: 2.2,
      mainAxisSpacing: 16.0,
      children: [
        _buildServiceCard(
          context,
          title: 'Lost Child Assistance',
          description: 'Protocol-driven immediate search and security alert.',
          icon: Icons.family_restroom,
          iconColor: const Color(0xFF6100D6),
          buttonText: 'Report Missing',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Starting Lost Child reporting flow...')),
            );
          },
        ),
        _buildServiceCard(
          context,
          title: 'First Aid',
          description: 'Medical assistance from certified first responders.',
          icon: Icons.medical_services,
          iconColor: const Color(0xFFBA1A1A),
          buttonText: 'Request First Aid',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EmergencyNavigationPage(destination: 'First Aid Room'),
              ),
            );
          },
        ),
        _buildServiceCard(
          context,
          title: 'Help Desk',
          description: 'Store directions, mall events, or general inquiries.',
          icon: Icons.support_agent,
          iconColor: const Color(0xFF0058BE),
          buttonText: 'Connect Now',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Connecting to Help Desk live support...')),
            );
          },
        ),
        _buildServiceCard(
          context,
          title: 'Accessibility',
          description: 'Wheelchairs, strollers, or specific access help.',
          icon: Icons.accessible,
          iconColor: const Color(0xFF813800),
          buttonText: 'Get Support',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Requesting Wheelchair / Stroller dispatch assistance...')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-24
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 24.0),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0, // title-md
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      description,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0, // body-md
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 44.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.circular(9999.0), // full
              ),
              alignment: Alignment.center,
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0, // label-lg
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection() {
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
          const Text(
            'How it works',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
            ),
          ),
          const SizedBox(height: 24.0),
          const EmergencyTimeline(
            steps: [
              EmergencyTimelineStep(
                title: 'Select Service',
                description: 'Choose the type of help you need from the list above.',
                icon: Icons.touch_app,
                isActive: true,
              ),
              EmergencyTimelineStep(
                title: 'Location Shared',
                description: 'We\'ll automatically ping your precise location to the team.',
                icon: Icons.share_location,
              ),
              EmergencyTimelineStep(
                title: 'Staff Assigned',
                description: 'Receive a live notification when a team member is on their way.',
                icon: Icons.notifications,
              ),
              EmergencyTimelineStep(
                title: 'Receive Assistance',
                description: 'Immediate on-site support until your issue is resolved.',
                icon: Icons.done_all,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
