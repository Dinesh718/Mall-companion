import 'package:flutter/material.dart';
import '../../domain/entities/parking_entities.dart';

class ParkingHeroCard extends StatefulWidget {
  final ParkingAvailabilityEntity availability;

  const ParkingHeroCard({super.key, required this.availability});

  @override
  State<ParkingHeroCard> createState() => _ParkingHeroCardState();
}

class _ParkingHeroCardState extends State<ParkingHeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.availability.occupancyPercentage / 100.0;

    return Container(
      height: 236.0,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.0), // rounded-xxl
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2FF7).withOpacity(0.2),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Shimmer/Light Ambient overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.transparent, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Live dot pulsar + Label
                        Row(
                          children: [
                            FadeTransition(
                              opacity: _pulseAnimation,
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4ADE80), // green-400
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              'LIVE AVAILABILITY',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xE6FFFFFF),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${widget.availability.availableSpaces}',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 36.0, // display-lg-mobile
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        const Text(
                          'Available Spaces',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        Icons.local_parking_rounded,
                        color: Colors.white,
                        size: 28.0,
                      ),
                    ),
                  ],
                ),

                // Progress occupancy bar & stats
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Occupancy',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xE6FFFFFF),
                          ),
                        ),
                        Text(
                          '${widget.availability.occupancyPercentage}%',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 10.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    // Footer details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.login,
                              size: 14.0,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              'Entry: ${widget.availability.entryRate}',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11.0,
                                color: Color(0xE6FFFFFF),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.logout,
                              size: 14.0,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              'Exit: ${widget.availability.exitRate}',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11.0,
                                color: Color(0xE6FFFFFF),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 14.0,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              widget.availability.estimatedEntryTime,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11.0,
                                color: Color(0xE6FFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
