import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'glass_card.dart';
import 'floating_widget.dart';
import '../bloc/permission_bloc.dart';
import '../bloc/permission_event.dart';

class LocationPermissionSlide extends StatelessWidget {
  const LocationPermissionSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 24.0),
          // 1. Center Illustration Area
          _buildIllustration(context),
          const SizedBox(height: 24.0),

          // 2. Text Section
          const Text(
            'Enable Location',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.64,
              color: Color(0xFF121C2A),
            ),
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Allow location access to help you navigate inside the mall, locate stores, remember your parking location and provide accurate indoor directions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF4A4456),
            ),
          ),
          const SizedBox(height: 24.0),

          // 3. Privacy Card
          _buildPrivacyCard(),
          const SizedBox(height: 32.0),

          // 4. Action Buttons
          _buildActionButtons(context),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background Glow element
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6100D6).withOpacity(0.05),
              ),
            ),
          ),
          // Main Glass Card
          FloatingWidget(
            offset: 12.0,
            child: GlassCard(
              borderRadius: 40.0,
              child: SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  children: [
                    // Grid background texture
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.15,
                        child: GridPaper(
                          color: const Color(0xFF6100D6),
                          divisions: 1,
                          subdivisions: 1,
                          interval: 60.0,
                          child: Container(),
                        ),
                      ),
                    ),
                    // Navigation Custom Painted Curve Route
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CustomPaint(painter: _RoutePathPainter()),
                      ),
                    ),
                    // Glowing Center Location Pin
                    Center(child: _PulsingLocationPin()),
                    // Glass Card Level 2 tag Overlay
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: GlassCard(
                        borderRadius: 16.0,
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF4FF),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: const Icon(
                                Icons.local_mall,
                                color: Color(0xFF6100D6),
                                size: 16.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'LEVEL 2',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF6100D6),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  'Luxury Avenue',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF121C2A),
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
            ),
          ),
          // Floating Direction Car badge (Top-Right)
          Positioned(
            top: -12.0,
            right: 0.0,
            child: FloatingWidget(
              delayFraction: 0.25,
              offset: 8.0,
              child: const GlassCard(
                padding: EdgeInsets.all(12.0),
                borderRadius: 16.0,
                child: Icon(
                  Icons.directions_car,
                  color: Color(0xFF0058BE),
                  size: 24.0,
                ),
              ),
            ),
          ),
          // Floating Storefront badge (Bottom-Left)
          Positioned(
            bottom: 32.0,
            left: 0.0,
            child: FloatingWidget(
              delayFraction: 0.4,
              offset: 8.0,
              child: const GlassCard(
                padding: EdgeInsets.all(10.0),
                borderRadius: 999.0,
                child: Icon(
                  Icons.storefront,
                  color: Color(0xFF6100D6),
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFF0058BE).withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.health_and_safety,
              color: Color(0xFF0058BE),
              size: 20.0,
            ),
          ),
          const SizedBox(width: 16.0),
          const Expanded(
            child: Text(
              'Your location is only used while helping you navigate inside the mall.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                height: 1.3,
                color: Color(0xFF4A4456),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Allow Location Button
        Container(
          width: double.infinity,
          height: 56.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FF7).withOpacity(0.2),
                blurRadius: 12.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              context.read<PermissionBloc>().add(
                const RequestLocationPermission(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'Allow Location',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        // Not Now Button
        TextButton(
          onPressed: () {
            context.read<PermissionBloc>().add(
              const LocationPermissionDenied(),
            );
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 48.0),
            foregroundColor: const Color(0xFF4A4456),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: const Text(
            'Not Now',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoutePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    paint.shader = const LinearGradient(
      colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final scaleX = size.width / 200.0;
    final scaleY = size.height / 200.0;

    path.moveTo(40.0 * scaleX, 160.0 * scaleY);
    path.cubicTo(
      60.0 * scaleX,
      100.0 * scaleY,
      140.0 * scaleX,
      100.0 * scaleY,
      160.0 * scaleX,
      40.0 * scaleY,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PulsingLocationPin extends StatefulWidget {
  @override
  State<_PulsingLocationPin> createState() => _PulsingLocationPinState();
}

class _PulsingLocationPinState extends State<_PulsingLocationPin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing background ring
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Opacity(
                opacity: (1.8 - _pulseAnimation.value) / 0.8,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6100D6).withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
        // Central Pin
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF6100D6),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 20.0),
        ),
      ],
    );
  }
}
