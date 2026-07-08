import 'package:flutter/material.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEADDFF), // primary-container
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Color(0xFF6100D6), // primary
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Benefits',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 18.0, // title-lg
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25), // on-surface
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      'Exclusive to Gold Members',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13.0, // body-md
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEDE5F5)),
          // Benefit list items
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildBenefitItem(
                  icon: Icons.confirmation_number,
                  title: 'Exclusive Offers',
                  subtitle: '4 active vouchers',
                  iconColor: const Color(0xFF6100D6), // primary
                ),
                const SizedBox(height: 16.0),
                _buildBenefitItem(
                  icon: Icons.event_available,
                  title: 'Priority Reservations',
                  subtitle: 'Skip the wait at dining outlets',
                  iconColor: const Color(0xFF0058BE), // secondary
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1FF), // bg-surface-container-low
        borderRadius: BorderRadius.circular(20.0), // rounded-2xl
      ),
      child: Row(
        children: [
          // Icon with white background & shadow
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15.0, // body-lg
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0, // label-md
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF7B7488), // outline
            size: 24.0,
          ),
        ],
      ),
    );
  }
}
