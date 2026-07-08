import 'package:flutter/material.dart';

class GuestFeatureCard extends StatelessWidget {
  const GuestFeatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      const _FeatureItem(
        icon: Icons.explore,
        title: 'Indoor Navigation',
        subtitle: 'Step-by-step guidance',
      ),
      const _FeatureItem(
        icon: Icons.search,
        title: 'Search',
        subtitle: 'Find shops & brands',
      ),
      const _FeatureItem(
        icon: Icons.theater_comedy,
        title: 'Theatres',
        subtitle: 'Now showing schedules',
      ),
      const _FeatureItem(
        icon: Icons.emergency,
        title: 'Assistance',
        subtitle: 'Help when you need it',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Explore Without Signing In',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // headline-md
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 500;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 2 : 1,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                mainAxisExtent: 88.0, // fixed height for feature cards
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                return features[index];
              },
            );
          },
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-card
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Icon Container with gradient background
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              gradient: const LinearGradient(
                colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16.0, // title-lg
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0, // body-md
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFFCCC3D9), // outline-variant
            size: 24.0,
          ),
        ],
      ),
    );
  }
}
