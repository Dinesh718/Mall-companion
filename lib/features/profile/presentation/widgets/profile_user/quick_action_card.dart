import 'package:flutter/material.dart';
import '../../../domain/entities/profile_entities.dart';

class QuickActionCard extends StatelessWidget {
  final UserProfileEntity userProfile;

  const QuickActionCard({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAccessItem(
        icon: Icons.favorite,
        title: 'Favorites',
        subtitle: '${userProfile.favorites.count} ${userProfile.favorites.label}',
        color: const Color(0xFF6100D6), // primary
      ),
      _QuickAccessItem(
        icon: Icons.local_parking,
        title: 'Saved Parking',
        subtitle: '${userProfile.parking.level}, ${userProfile.parking.spot}',
        color: const Color(0xFF0058BE), // secondary
      ),
      _QuickAccessItem(
        icon: Icons.restaurant,
        title: 'Reservations',
        subtitle: userProfile.reservation.subtitle,
        color: const Color(0xFF813800), // tertiary
      ),
      const _QuickAccessItem(
        icon: Icons.map,
        title: 'Offline Maps',
        subtitle: '2 Maps Available',
        color: Color(0xFFBA1A1A), // error
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Quick Access',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.12,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            return actions[index];
          },
        ),
      ],
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _QuickAccessItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0), // rounded-card
        border: Border.all(
          color: const Color(0xFFF3EBFA), // border-surface-container
          width: 1.0,
        ),
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
          // Icon Container
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16.0), // rounded-2xl
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: color,
              size: 22.0,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15.0, // body-lg font-semibold
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1A25), // on-surface
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11.0, // label-md
                  color: Color(0xFF4A4456), // on-surface-variant
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.chevron_right,
                color: const Color(0xFF4A4456).withOpacity(0.7),
                size: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
