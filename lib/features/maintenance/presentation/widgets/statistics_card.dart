import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final int totalReports;
  final int resolved;
  final int inProgress;
  final int pending;
  final String avgTime;

  const StatisticsCard({
    super.key,
    required this.totalReports,
    required this.resolved,
    required this.inProgress,
    required this.pending,
    required this.avgTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        children: [
          // Total Reports Card (Gradient)
          _buildTotalCard(),
          const SizedBox(width: 16.0),
          // Resolved Card
          _buildStatCard(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF16A34A), // green-600
            circleColor: const Color(0xFFDCFCE7), // green-50
            label: 'Resolved',
            value: resolved.toString(),
          ),
          const SizedBox(width: 16.0),
          // In Progress Card
          _buildStatCard(
            icon: Icons.sync,
            iconColor: const Color(0xFF2563EB), // blue-600
            circleColor: const Color(0xFFDBEAFE), // blue-50
            label: 'In Progress',
            value: inProgress.toString(),
          ),
          const SizedBox(width: 16.0),
          // Pending Card
          _buildStatCard(
            icon: Icons.pending,
            iconColor: const Color(0xFFEA580C), // orange-600
            circleColor: const Color(0xFFFFEDD5), // orange-50
            label: 'Pending',
            value: pending.toString(),
          ),
          const SizedBox(width: 16.0),
          // Avg Time Card
          _buildStatCard(
            icon: Icons.schedule,
            iconColor: const Color(0xFF7C3AED), // purple-600
            circleColor: const Color(0xFFF3E8FF), // purple-50
            label: 'Avg. Time',
            value: avgTime,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      width: 160.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)], // primary-gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2FF7).withOpacity(0.15),
            blurRadius: 15.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.analytics_outlined, color: Colors.white, size: 24.0),
              SizedBox(height: 8.0),
              Text(
                'Total Reports',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Text(
            totalReports.toString(),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color circleColor,
    required String label,
    required String value,
  }) {
    return Container(
      width: 160.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20.0),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.0,
                  color: Color(0xFF4A4456), // on-surface-variant
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30), // on-surface
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
