import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String location;
  final String nearestLandmark;
  final String status;
  final VoidCallback onRefresh;

  const LocationCard({
    super.key,
    required this.location,
    required this.nearestLandmark,
    required this.status,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isLocating = status == 'Locating...';

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0), // rounded-[28px]
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pulse Location pin container
          Stack(
            alignment: Alignment.center,
            children: [
              if (!isLocating)
                _PulseRadarRing(),
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF6100D6).withOpacity(0.1), // primary/10
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isLocating
                    ? const SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
                        ),
                      )
                    : const Icon(
                        Icons.location_on,
                        color: Color(0xFF6100D6), // primary
                        size: 24.0,
                      ),
              ),
            ],
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOCATION STATUS: $status'.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0058BE), // secondary
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  location,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1C30), // on-surface
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'Near $nearestLandmark',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF6100D6)),
            onPressed: isLocating ? null : onRefresh,
          ),
        ],
      ),
    );
  }
}

class _PulseRadarRing extends StatefulWidget {
  @override
  State<_PulseRadarRing> createState() => _PulseRadarRingState();
}

class _PulseRadarRingState extends State<_PulseRadarRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 48.0 + (32.0 * _controller.value),
          height: 48.0 + (32.0 * _controller.value),
          decoration: BoxDecoration(
            color: const Color(0xFF6100D6).withOpacity(0.2 * (1.0 - _controller.value)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
