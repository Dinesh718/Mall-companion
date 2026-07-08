import 'package:flutter/material.dart';

class GuestBenefitsCard extends StatelessWidget {
  const GuestBenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final benefits = [
      _BenefitItem(icon: Icons.favorite, label: 'Favorite Stores'),
      _BenefitItem(icon: Icons.restaurant, label: 'Dining Res'),
      _BenefitItem(icon: Icons.local_parking, label: 'Saved Parking'),
      _BenefitItem(icon: Icons.cloud_sync, label: 'Cloud Sync'),
      _BenefitItem(icon: Icons.confirmation_number, label: 'Tickets'),
      _BenefitItem(icon: Icons.auto_awesome, label: 'For You'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unlock More with an Account',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20.0, // headline-md (20-24px)
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1A25), // on-surface
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'Sign in to save your experience across devices.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14.0, // body-md
                  color: Color(0xFF4A4456), // on-surface-variant
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.95,
          ),
          itemCount: benefits.length,
          itemBuilder: (context, index) {
            return benefits[index];
          },
        ),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BenefitItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Icon background container
          Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
              color: Color(0xFFD8E2FF), // secondary-fixed / secondary-container/10
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: const Color(0xFF0058BE), // secondary
              size: 20.0,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11.0, // label-md
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1A25), // on-surface
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
