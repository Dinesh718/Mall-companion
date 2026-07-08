import 'package:flutter/material.dart';

class MaintenanceHeroCard extends StatelessWidget {
  final VoidCallback onStartTap;

  const MaintenanceHeroCard({
    super.key,
    required this.onStartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)], // primary-container to secondary-container
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background blurry circle
          Positioned(
            right: -64.0,
            top: -64.0,
            child: Container(
              width: 256.0,
              height: 256.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Illustration Image on the right
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.4,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDtKZ1lyhw_dfrs5LlSvdgSkw9eRJpN67KQQAo46iW1ZtbQo8HX9yY4InKBk44DszfGvpj8YOk118v9RsWnFIsegJ9gXq4n3hhR_7sSFWhnFD_d1a4jkdD2nM1vHNH07MJKMuREtdFwG-hMX4KukoOa-ME5s9FwESc1jg4tcb0mW1P0id7AnsSJ6O9maGum-E9BvMtODrAHkqFMnjc057_4NQLfX0Eyuzf6jiO6g_ysJ9oFj_V4cPimB-FiT7YYTLjhcS6lAbm4QQ',
                width: 180.0,
                height: 180.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(9999.0),
                      ),
                      child: const Text(
                        'Fast Response',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(9999.0),
                      ),
                      child: const Text(
                        'Location Aware',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const SizedBox(
                  width: 220.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maintenance Reporting',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Report issues instantly and help us improve the mall experience. Our facility team is ready to assist.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: onStartTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Start Report',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
