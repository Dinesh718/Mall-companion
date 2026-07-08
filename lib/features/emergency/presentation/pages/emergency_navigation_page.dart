import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Usecases & Repository
import '../../data/datasources/emergency_local_datasource.dart';
import '../../data/repositories/emergency_repository_impl.dart';
import '../../domain/entities/emergency_entities.dart';
import '../../domain/usecases/emergency_usecases.dart';

// BLoC
import '../bloc/emergency_bloc.dart';
import '../bloc/emergency_event.dart';
import '../bloc/emergency_state.dart';

// Reusable Widgets
import '../widgets/emergency_route_card.dart';
import '../widgets/emergency_status_card.dart';
import '../widgets/emergency_tips_card.dart';
import '../widgets/emergency_ui_states.dart';

class EmergencyNavigationPage extends StatelessWidget {
  final String destination;

  const EmergencyNavigationPage({
    super.key,
    required this.destination,
  });

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
      )..add(StartEmergencyNavigation(destination: destination)),
      child: const _EmergencyNavigationView(),
    );
  }
}

class _EmergencyNavigationView extends StatelessWidget {
  const _EmergencyNavigationView();

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
          'Emergency Navigation',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1A25),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF6100D6)),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Aura decorations
          Positioned(
            top: -48.0,
            left: -48.0,
            child: Container(
              width: 192.0,
              height: 192.0,
              decoration: BoxDecoration(
                color: const Color(0xFF6100D6).withOpacity(0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          BlocBuilder<EmergencyBloc, EmergencyState>(
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

              if (state is EmergencyNavigationLoaded) {
                final route = state.route;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle
                      const Text(
                        'Emergency Navigation',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24.0, // headline-lg-mobile
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1A25),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Fastest safe route to your selected emergency destination.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.0,
                          color: Color(0xFF4A4456),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // Route Hero Card
                      _buildRouteHero(route),
                      const SizedBox(height: 24.0),
                      // Live Safety Status chips
                      const EmergencyStatusCard(),
                      const SizedBox(height: 24.0),
                      // Map View container
                      _buildMapView(),
                      const SizedBox(height: 24.0),
                      // Step timelines guidance
                      EmergencyRouteCard(steps: route.steps),
                      const SizedBox(height: 32.0),
                      // Alternative Routes horizontal list
                      _buildAlternativeRoutes(),
                      const SizedBox(height: 32.0),
                      // Safety tips
                      const EmergencyTipsCard(
                        sectionTitle: 'Safety Precautions',
                        tips: [
                          EmergencyTipItem(
                            text: 'Remain calm and move steadily',
                            icon: Icons.sentiment_satisfied_outlined,
                          ),
                          EmergencyTipItem(
                            text: 'Follow illuminated exit signs',
                            icon: Icons.lightbulb_outline,
                          ),
                          EmergencyTipItem(
                            text: 'Avoid using elevators',
                            icon: Icons.elevator_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 64.0),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHero(EmergencyNavigationRouteEntity route) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)], // primary to secondary
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.directions_run, color: Colors.white, size: 18.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Destination',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11.0, color: Colors.white70),
                    ),
                    Text(
                      route.destinationName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimated Time',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 11.0, color: Colors.white70),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.white, size: 14.0),
                      const SizedBox(width: 4.0),
                      Text(
                        '${route.estimatedMinutes} Minutes',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distance',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 11.0, color: Colors.white70),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.straighten, color: Colors.white, size: 14.0),
                      const SizedBox(width: 4.0),
                      Text(
                        '${route.distanceMeter.toInt()} meters',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const Divider(height: 1.0, color: Colors.white24),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.layers, color: Colors.white, size: 14.0),
                  const SizedBox(width: 4.0),
                  Text(
                    route.currentFloor,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 13.0, color: Colors.white),
                  ),
                ],
              ),
              if (route.isSafeRouteActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(9999.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6.0,
                        height: 6.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ADE80), // green-400
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      const Text(
                        'Safe Route Active',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      height: 400.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF), // Map light blueprint bg
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Blueprint lines
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _BlueprintGridPainter(),
              ),
            ),
          ),
          // Route path drawing
          Positioned.fill(
            child: CustomPaint(
              painter: _RoutePathPainter(),
            ),
          ),
          // Landmarks overlay text
          const Positioned(
            top: 80.0,
            left: 160.0,
            child: Column(
              children: [
                Icon(Icons.medical_services, color: Color(0xFF0058BE), size: 18.0),
                Text(
                  'First Aid',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 10.0, fontWeight: FontWeight.bold, color: Color(0xFF0058BE)),
                ),
              ],
            ),
          ),
          // Floating controls
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              children: [
                _buildMapControlBtn(Icons.my_location),
                const SizedBox(height: 12.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      _buildMapControlBtn(Icons.add, isHalf: true),
                      const Divider(height: 1.0, color: Colors.black12),
                      _buildMapControlBtn(Icons.remove, isHalf: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlBtn(IconData icon, {bool isHalf = false}) {
    return Container(
      width: 48.0,
      height: isHalf ? 40.0 : 48.0,
      decoration: isHalf
          ? null
          : BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
      alignment: Alignment.center,
      child: Icon(icon, color: const Color(0xFF6100D6), size: 20.0),
    );
  }

  Widget _buildAlternativeRoutes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Alternative Routes',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          height: 120.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildAlternativeRouteCard(
                title: 'Second Exit (South)',
                status: 'Moderate Crowd',
                minutes: 4,
                distance: 280,
                icon: Icons.alt_route,
                statusBg: const Color(0xFFDCFCE7),
                statusFg: const Color(0xFF16A34A),
              ),
              const SizedBox(width: 16.0),
              _buildAlternativeRouteCard(
                title: 'Accessible Exit',
                status: 'Low Crowd',
                minutes: 6,
                distance: 400,
                icon: Icons.accessible,
                statusBg: const Color(0xFFDBEAFE),
                statusFg: const Color(0xFF2563EB),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlternativeRouteCard({
    required String title,
    required String status,
    required int minutes,
    required int distance,
    required IconData icon,
    required Color statusBg,
    required Color statusFg,
  }) {
    return Container(
      width: 260.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF4FF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: const Color(0xFF6100D6), size: 18.0),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(9999.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.0,
                    fontWeight: FontWeight.bold,
                    color: statusFg,
                  ),
                ),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.timer, color: Color(0xFF4A4456), size: 12.0),
              const SizedBox(width: 4.0),
              Text(
                '$minutes min',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 11.0, color: Color(0xFF4A4456)),
              ),
              const SizedBox(width: 16.0),
              const Icon(Icons.straighten, color: Color(0xFF4A4456), size: 12.0),
              const SizedBox(width: 4.0),
              Text(
                '${distance}m',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 11.0, color: Color(0xFF4A4456)),
              ),
            ],
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
      ..color = const Color(0xFF0058BE).withOpacity(0.04)
      ..strokeWidth = 1.0;

    double gridSpacing = 20.0;

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

class _RoutePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw corridor outline guidelines
    final outlinePaint = Paint()
      ..color = const Color(0xFF0058BE).withOpacity(0.2)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final pathOutline = Path()
      ..moveTo(50, 100)
      ..lineTo(350, 100)
      ..lineTo(350, 300)
      ..lineTo(50, 300)
      ..close();
    canvas.drawPath(pathOutline, outlinePaint);

    final pathConnector = Path()
      ..moveTo(150, 100)
      ..lineTo(150, 200)
      ..lineTo(250, 200)
      ..lineTo(250, 300);
    canvas.drawPath(pathConnector, outlinePaint);

    // 2. Draw actual routing path line
    final routePaint = Paint()
      ..color = const Color(0xFF7B2FF7)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final routePath = Path()
      ..moveTo(100, 250)
      ..quadraticBezierTo(150, 250, 150, 200)
      ..quadraticBezierTo(150, 150, 250, 100);
    canvas.drawPath(routePath, routePaint);

    // 3. Draw start point circle
    final pointPaint = Paint()..color = const Color(0xFF0058BE);
    canvas.drawCircle(const Offset(100, 250), 6.0, pointPaint);
    canvas.drawCircle(const Offset(100, 250), 12.0, pointPaint..color = const Color(0xFF0058BE).withOpacity(0.2));

    // 4. Draw exit box node
    final destBoxPaint = Paint()..color = const Color(0xFF6100D6);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(235, 85, 30, 30), const Radius.circular(4.0)), destBoxPaint);

    // 5. Draw exit door icon inside box
    final textPainter = TextPainter(
      text: TextSpan(
        text: '\uE8BE', // exit_to_app icon code point
        style: TextStyle(
          fontFamily: 'MaterialIcons',
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(242, 92));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
