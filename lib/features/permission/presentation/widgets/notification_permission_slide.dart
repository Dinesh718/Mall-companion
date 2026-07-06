import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'glass_card.dart';
import 'floating_widget.dart';
import '../bloc/permission_bloc.dart';
import '../bloc/permission_event.dart';

class NotificationPermissionSlide extends StatelessWidget {
  const NotificationPermissionSlide({super.key});

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
            'Stay Updated',
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
            'Receive exclusive offers, event reminders, parking alerts and important mall announcements.',
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
                color: const Color(0xFF6100D6).withOpacity(0.04),
              ),
            ),
          ),
          // Main Bell Glass Card
          FloatingWidget(
            offset: 12.0,
            duration: const Duration(seconds: 4),
            child: GlassCard(
              borderRadius: 40.0,
              padding: const EdgeInsets.all(32.0),
              child: const Icon(
                Icons.notifications_active,
                color: Color(0xFF6100D6),
                size: 96.0,
              ),
            ),
          ),
          // Floating Offer Tag (Top Left)
          Positioned(
            top: 20.0,
            left: -15.0,
            child: FloatingWidget(
              delayFraction: 0.1,
              offset: 8.0,
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                borderRadius: 16.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.sell, color: Color(0xFF6100D6), size: 16.0),
                    SizedBox(width: 8.0),
                    Text(
                      'Exclusive Offer',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating Event Seat Circle (Bottom Right)
          Positioned(
            bottom: 40.0,
            right: -10.0,
            child: FloatingWidget(
              delayFraction: 0.3,
              offset: 8.0,
              child: const GlassCard(
                padding: EdgeInsets.all(12.0),
                borderRadius: 999.0,
                child: Icon(
                  Icons.event_seat,
                  color: Color(0xFF0058BE),
                  size: 20.0,
                ),
              ),
            ),
          ),
          // Floating Parking Tag (Top Right)
          Positioned(
            top: 50.0,
            right: -15.0,
            child: FloatingWidget(
              delayFraction: 0.5,
              offset: 8.0,
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                borderRadius: 999.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.local_parking,
                      color: Color(0xFFBA1A1A),
                      size: 16.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      'Level 2 Free',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating Alert Bubble (Bottom Left)
          Positioned(
            bottom: 60.0,
            left: -10.0,
            child: FloatingWidget(
              delayFraction: 0.2,
              offset: 8.0,
              child: GlassCard(
                padding: const EdgeInsets.all(12.0),
                borderRadius: 999.0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6100D6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return GlassCard(
      borderRadius: 16.0,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EEFF),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Icon(
              Icons.verified_user,
              color: Color(0xFF6100D6),
              size: 20.0,
            ),
          ),
          const SizedBox(width: 16.0),
          const Expanded(
            child: Text(
              'Notifications can be turned off anytime from your device settings.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
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
        // Allow Notifications Button
        Container(
          width: double.infinity,
          height: 56.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999.0),
            gradient: const LinearGradient(
              colors: [Color(0xFF7423F0), Color(0xFF6100D6)],
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
                const RequestNotificationPermission(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999.0),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'Allow Notifications',
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
        // Maybe Later Button
        TextButton(
          onPressed: () {
            context.read<PermissionBloc>().add(
              const SkipNotificationPermission(),
            );
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 56.0),
            foregroundColor: const Color(0xFF4A4456),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999.0),
            ),
          ),
          child: const Text(
            'Maybe Later',
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
