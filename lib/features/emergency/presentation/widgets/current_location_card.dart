import 'package:flutter/material.dart';

class CurrentLocationCard extends StatelessWidget {
  final String mallName;
  final String floorAndWing;
  final String securityDeskDistance;
  final String estimatedArrival;
  final String statusBadgeText;

  const CurrentLocationCard({
    super.key,
    this.mallName = 'North Star Mall',
    this.floorAndWing = 'Level 2 • Near North Wing',
    this.securityDeskDistance = 'North Wing (45m away)',
    this.estimatedArrival = '~ 3 min',
    this.statusBadgeText = 'Security Team: Assigned',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-24
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
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF6100D6).withOpacity(0.1), // primary/10
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFF6100D6), // primary
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mallName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0, // title-md
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30), // on-surface
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      floorAndWing,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0, // body-md
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Divider(height: 1.0, color: Color(0xFFEFF4FF)),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SECURITY DESK',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9.0, // label-sm
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4456), // on-surface-variant
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    securityDeskDistance,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0B1C30),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EST. ARRIVAL',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9.0, // label-sm
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4456),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    estimatedArrival,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6100D6), // primary
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFEADDFF), // primary-container/20
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: Alignment.center,
            child: Text(
              statusBadgeText,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.0, // label-lg
                fontWeight: FontWeight.bold,
                color: Color(0xFF6100D6), // primary
              ),
            ),
          ),
        ],
      ),
    );
  }
}
