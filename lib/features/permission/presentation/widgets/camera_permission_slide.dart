import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'glass_card.dart';
import 'floating_widget.dart';
import '../bloc/permission_bloc.dart';
import '../bloc/permission_event.dart';

class CameraPermissionSlide extends StatelessWidget {
  const CameraPermissionSlide({super.key});

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
            'Enable Camera',
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
            'Camera access allows AR Navigation and QR code scanning for an enhanced shopping experience.',
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
          // Main Smartphone visual
          FloatingWidget(
            offset: 10.0,
            duration: const Duration(seconds: 5),
            child: Container(
              width: 150,
              height: 250,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFE6EEFF,
                ), // surface-container-highest / borders
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    blurRadius: 20.0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(23.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Camera simulation frame (dashed)
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF6100D6).withOpacity(0.3),
                            width: 2.0,
                            style: BorderStyle
                                .values[0], // dashed effect via borders / styling or simple border
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_2,
                              color: const Color(0xFF6100D6).withOpacity(0.4),
                              size: 48.0,
                            ),
                            // Corners
                            _buildQrCorner(Alignment.topLeft),
                            _buildQrCorner(Alignment.topRight),
                            _buildQrCorner(Alignment.bottomLeft),
                            _buildQrCorner(Alignment.bottomRight),
                          ],
                        ),
                      ),
                      // Scan Line
                      _ScanLine(),
                      // Top notch simulation
                      Positioned(
                        top: 0,
                        child: Container(
                          width: 50,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE6EEFF),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating Badge 1 (Top-Right): Navigation pointer
          Positioned(
            top: 40.0,
            right: -10.0,
            child: FloatingWidget(
              delayFraction: 0.15,
              offset: 8.0,
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                borderRadius: 16.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.navigation,
                      color: Color(0xFF0058BE),
                      size: 14.0,
                    ),
                    const SizedBox(width: 6.0),
                    Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0058BE).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating Badge 2 (Bottom-Left): Distance indicator
          Positioned(
            bottom: 30.0,
            left: -15.0,
            child: FloatingWidget(
              delayFraction: 0.35,
              offset: 8.0,
              child: const GlassCard(
                padding: EdgeInsets.all(12.0),
                borderRadius: 999.0,
                child: Icon(
                  Icons.social_distance,
                  color: Color(0xFF6100D6),
                  size: 24.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? const BorderSide(color: Color(0xFF6100D6), width: 2.0)
                : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Color(0xFF6100D6), width: 2.0)
                : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? const BorderSide(color: Color(0xFF6100D6), width: 2.0)
                : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Color(0xFF6100D6), width: 2.0)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.4),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFF6100D6).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Icon(
              Icons.privacy_tip_outlined,
              color: Color(0xFF6100D6),
              size: 20.0,
            ),
          ),
          const SizedBox(width: 16.0),
          const Expanded(
            child: Text(
              'The camera is only used while using AR Navigation or scanning QR codes.',
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
        // Allow Camera Button
        Container(
          width: double.infinity,
          height: 56.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: const LinearGradient(
              colors: [Color(0xFF6100D6), Color(0xFF2170E4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6100D6).withOpacity(0.2),
                blurRadius: 12.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              context.read<PermissionBloc>().add(
                const RequestCameraPermission(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'Allow Camera',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        // Not Now Button
        TextButton(
          onPressed: () {
            context.read<PermissionBloc>().add(const CameraPermissionDenied());
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 56.0),
            foregroundColor: const Color(0xFF4A4456),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
          child: const Text(
            'Not Now',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanLine extends StatefulWidget {
  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.1,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top:
              240.0 *
              _animation.value, // based on Smartphone height (approx 240)
          left: 12,
          right: 12,
          child: Opacity(
            opacity: 0.8,
            child: Container(
              height: 2.0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0xFF6100D6),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6100D6),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
