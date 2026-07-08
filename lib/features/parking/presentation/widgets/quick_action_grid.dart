import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.0), // rounded-xxl (28px)
          border: Border.all(
            color: const Color(0xFFE8DFEF).withOpacity(0.5),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0), // p-5
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24.0),
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.0, // label-lg
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1A25), // on-surface
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionGrid extends StatelessWidget {
  final VoidCallback onSaveTap;
  final VoidCallback onFindTap;
  final VoidCallback onMapTap;
  final VoidCallback onZonesTap;

  const QuickActionGrid({
    super.key,
    required this.onSaveTap,
    required this.onFindTap,
    required this.onMapTap,
    required this.onZonesTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 1.15,
      ),
      children: [
        QuickActionCard(
          icon: Icons.pin_drop,
          title: 'Save Location',
          iconColor: const Color(0xFF6100D6), // primary
          bgColor: const Color(0xFFEADDFF), // primary-fixed
          onTap: onSaveTap,
        ),
        QuickActionCard(
          icon: Icons.directions_car_filled_outlined,
          title: 'Find My Vehicle',
          iconColor: const Color(0xFF0058BE), // secondary
          bgColor: const Color(0xFFD8E2FF), // secondary-fixed
          onTap: onFindTap,
        ),
        QuickActionCard(
          icon: Icons.layers_outlined,
          title: 'Parking Map',
          iconColor: const Color(0xFF813800), // tertiary
          bgColor: const Color(0xFFFFDBCA), // tertiary-fixed
          onTap: onMapTap,
        ),
        QuickActionCard(
          icon: Icons.dashboard_outlined,
          title: 'Parking Zones',
          iconColor: const Color(0xFF4A4456), // on-surface-variant
          bgColor: const Color(0xFFEDE5F5), // surface-container-high
          onTap: onZonesTap,
        ),
      ],
    );
  }
}
