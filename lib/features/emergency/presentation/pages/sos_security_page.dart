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
import '../widgets/current_location_card.dart';
import '../widgets/emergency_contact_card.dart';
import '../widgets/emergency_timeline.dart';
import '../widgets/emergency_tips_card.dart';
import '../widgets/emergency_ui_states.dart';

// Pages
import 'emergency_navigation_page.dart';

class SOSSecurityPage extends StatelessWidget {
  const SOSSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = EmergencyLocalDataSourceImpl();
    final repository = EmergencyRepositoryImpl(
      localDataSource: localDataSource,
    );

    return BlocProvider(
      create: (_) => EmergencyBloc(
        loadEmergencyFacilitiesUseCase: LoadEmergencyFacilitiesUseCase(
          repository,
        ),
        loadEmergencyContactsUseCase: LoadEmergencyContactsUseCase(repository),
        startEmergencyNavigationUseCase: StartEmergencyNavigationUseCase(
          repository,
        ),
        sendSOSUseCase: SendSOSUseCase(repository),
        notifySecurityUseCase: NotifySecurityUseCase(repository),
        loadInstructionsUseCase: LoadInstructionsUseCase(repository),
      )..add(const LoadEmergencyContacts()),
      child: const _SOSSecurityView(),
    );
  }
}

class _SOSSecurityView extends StatelessWidget {
  const _SOSSecurityView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmergencyBloc, EmergencyState>(
      listener: (context, state) {
        if (state is SOSSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.alertMessage),
              backgroundColor: const Color(0xFF6100D6),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF7FF),
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.6),
          elevation: 0,
          scrolledUnderElevation: 1.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1A25)),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SOS & Security',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1A25),
                ),
              ),
              Text(
                'Immediate assistance whenever you need it',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.0,
                  color: Color(0xFF4A4456),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF1D1A25)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFF1D1A25)),
              onPressed: () {},
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Block
              _buildSOSHero(context),
              const SizedBox(height: 24.0),
              // Current Location Status Card
              const CurrentLocationCard(),
              const SizedBox(height: 24.0),
              // Grid of Options
              _buildOptionsGrid(context),
              const SizedBox(height: 32.0),
              // Process timeline
              _buildTimelineSection(),
              const SizedBox(height: 32.0),
              // Contacts list
              BlocBuilder<EmergencyBloc, EmergencyState>(
                builder: (context, state) {
                  if (state is EmergencyContactsLoaded) {
                    return EmergencyContactCard(
                      contacts: state.contacts,
                      onCallTap: (number) {
                        context.read<EmergencyBloc>().add(const CallSecurity());
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              const SizedBox(height: 32.0),
              // Safety protocol guidelines
              const EmergencyTipsCard(
                sectionTitle: 'Safety Protocol',
                tips: [
                  EmergencyTipItem(
                    text: 'Only use SOS during true emergencies',
                    icon: Icons.warning_amber,
                  ),
                  EmergencyTipItem(
                    text: 'Remain calm and breathe deeply',
                    icon: Icons.healing,
                  ),
                  EmergencyTipItem(
                    text: 'Stay where you are if possible',
                    icon: Icons.pin_drop,
                  ),
                  EmergencyTipItem(
                    text: 'Follow security instructions',
                    icon: Icons.assignment_turned_in,
                  ),
                ],
              ),
              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSOSHero(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0), // rounded-24
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)], // primary-gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -24.0,
            top: -24.0,
            child: Container(
              width: 180.0,
              height: 180.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -20.0,
            bottom: -20.0,
            child: Opacity(
              opacity: 0.3,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida/AP1WRLs41jbaC6579ro1CmtkMzklReAomE7ZyvvkwNUDM_XWTGzs4lGRv6rjpeMHNFLXIZNaAUSnPo5aT4158fUTJOGIiaB41xONMb3278hl89Fu0jTDIqp_oItF2wTBhYiTU_T3y8l-brWLnYjkWiCCKdQk5vpL75TI2bOgl4Q3Su0AIbNAVWx3JP0NzLJ8xbwXnE2Nshehwpx_99t9VxtVRKLTkG0wjwpfEQX-ZbHPEGG3i7U3bMPqYrxh',
                width: 180.0,
                height: 180.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(9999.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ADE80),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Security Team Online • 24x7 Monitoring',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Emergency Assistance',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24.0, // headline-lg-mobile
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240.0),
                  child: const Text(
                    'Pressing the SOS button will share your precise location with our security dispatch and initiate an immediate response.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      color: Color(0xE6FFFFFF),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<EmergencyBloc>().add(const OpenSOS());
                      },
                      icon: const Icon(
                        Icons.emergency,
                        color: Color(0xFF6100D6),
                        size: 18.0,
                      ),
                      label: const Text('Send SOS Alert'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6100D6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 14.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<EmergencyBloc>().add(const CallSecurity());
                      },
                      icon: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      label: const Text('Call Security'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 14.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
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

  Widget _buildOptionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          childAspectRatio: 4.8,
          mainAxisSpacing: 12.0,
          children: [
            _buildOptionTile(
              context,
              icon: Icons.notifications_active,
              color: const Color(0xFF6100D6),
              title: 'Notify Security',
              subtitle: 'Silent notification',
              onTap: () {
                context.read<EmergencyBloc>().add(const NotifySecurity());
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.chat,
              color: const Color(0xFF6100D6),
              title: 'Live Chat',
              subtitle: 'Chat with support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Starting Live Chat support connection...'),
                  ),
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.phone_callback,
              color: const Color(0xFF6100D6),
              title: 'Voice Call',
              subtitle: 'Instant audio link',
              onTap: () {
                context.read<EmergencyBloc>().add(const CallSecurity());
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.score,
              color: const Color(0xFF6100D6),
              title: 'Request Escort',
              subtitle: 'To your vehicle',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Escort dispatch requested. Security team member is on their way.',
                    ),
                  ),
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.medical_services,
              color: const Color(0xFFBA1A1A),
              title: 'Medical Aid',
              subtitle: 'Emergency first aid',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmergencyNavigationPage(
                      destination: 'First Aid Room',
                    ),
                  ),
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.fire_extinguisher,
              color: const Color(0xFFBA1A1A),
              title: 'Fire Emergency',
              subtitle: 'Report a fire incident',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmergencyNavigationPage(
                      destination: 'Fire Exit North',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-24
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        leading: Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FF),
            borderRadius: BorderRadius.circular(12.0),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 24.0),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0, // title-md
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1A25),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.0, // label-sm
            color: Color(0xFF4A4456),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFCCC3D9)),
      ),
    );
  }

  Widget _buildTimelineSection() {
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
            'SOS Process',
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
                title: 'Tap SOS',
                description: 'Initiate emergency alert',
                icon: Icons.touch_app,
                isActive: true,
              ),
              EmergencyTimelineStep(
                title: 'Location Shared',
                description: 'Real-time tracking activated',
                icon: Icons.share_location,
              ),
              EmergencyTimelineStep(
                title: 'Security Notified',
                description: 'Alert reaches command center',
                icon: Icons.notifications,
              ),
              EmergencyTimelineStep(
                title: 'Team Assigned',
                description: 'Personnel dispatched to your floor',
                icon: Icons.groups,
              ),
              EmergencyTimelineStep(
                title: 'Help Arrives',
                description: 'Security reaches your location',
                icon: Icons.done_all,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
