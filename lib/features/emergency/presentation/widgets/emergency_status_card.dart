import 'package:flutter/material.dart';

class EmergencyStatusCard extends StatelessWidget {
  const EmergencyStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildStatusChip(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF16A34A),
            label: 'Route Clear',
          ),
          const SizedBox(width: 12.0),
          _buildStatusChip(
            icon: Icons.groups,
            iconColor: const Color(0xFF6100D6),
            label: 'Emergency Team Nearby',
          ),
          const SizedBox(width: 12.0),
          _buildStatusChip(
            icon: Icons.notifications_active,
            iconColor: const Color(0xFFEA580C),
            label: 'Command Center Monitoring',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999.0), // rounded-full
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18.0),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.0, // label-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30), // on-surface
            ),
          ),
        ],
      ),
    );
  }
}
