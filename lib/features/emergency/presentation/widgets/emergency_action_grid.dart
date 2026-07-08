import 'package:flutter/material.dart';

class EmergencyActionGrid extends StatelessWidget {
  final VoidCallback onSosTap;
  final VoidCallback onSecurityDeskTap;
  final VoidCallback onFireExitTap;
  final VoidCallback onFirstAidTap;
  final VoidCallback onLostChildTap;
  final VoidCallback onHelpDeskTap;

  const EmergencyActionGrid({
    super.key,
    required this.onSosTap,
    required this.onSecurityDeskTap,
    required this.onFireExitTap,
    required this.onFirstAidTap,
    required this.onLostChildTap,
    required this.onHelpDeskTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.15,
          ),
          children: [
            // 1. SOS Highlight Card
            _buildActionCard(
              title: 'SOS',
              subtitle: 'Immediate alert',
              icon: Icons.emergency,
              iconColor: const Color(0xFFBA1A1A),
              circleColor: const Color(0xFFFFDAD6),
              isHighlight: true,
              onTap: onSosTap,
            ),
            // 2. Security Desk Card
            _buildActionCard(
              title: 'Security Desk',
              subtitle: 'Patrol dispatch',
              icon: Icons.security,
              iconColor: Colors.white,
              circleColor: const Color(0xFF0058BE),
              onTap: onSecurityDeskTap,
            ),
            // 3. Fire Exit Card
            _buildActionCard(
              title: 'Fire Exit',
              subtitle: 'Safe routes',
              icon: Icons.exit_to_app,
              iconColor: const Color(0xFFEA580C),
              circleColor: const Color(0xFFFFEDD5),
              onTap: onFireExitTap,
            ),
            // 4. First Aid Card
            _buildActionCard(
              title: 'First Aid',
              subtitle: 'Medical help',
              icon: Icons.medical_services,
              iconColor: const Color(0xFF16A34A),
              circleColor: const Color(0xFFDCFCE7),
              onTap: onFirstAidTap,
            ),
            // 5. Lost Child Card
            _buildActionCard(
              title: 'Lost Child',
              subtitle: 'Announcement',
              icon: Icons.child_care,
              iconColor: const Color(0xFF2563EB),
              circleColor: const Color(0xFFDBEAFE),
              onTap: onLostChildTap,
            ),
            // 6. Help Desk Card
            _buildActionCard(
              title: 'Help Desk',
              subtitle: 'General info',
              icon: Icons.support_agent,
              iconColor: const Color(0xFF7C3AED),
              circleColor: const Color(0xFFF3E8FF),
              onTap: onHelpDeskTap,
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color circleColor,
    bool isHighlight = false,
    required VoidCallback onTap,
  }) {
    final cardBg = isHighlight
        ? const Color(0xFFFFDAD6).withOpacity(0.3)
        : Colors.white;
    final borderColor = isHighlight
        ? const Color(0xFFFFDAD6)
        : const Color(0xFFCCC3D9).withOpacity(0.2);
    final labelColor = isHighlight
        ? const Color(0xFFBA1A1A)
        : const Color(0xFF0B1C30);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24.0), // rounded-24
          border: Border.all(
            color: borderColor,
            width: isHighlight ? 2.0 : 1.0,
          ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: circleColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: iconColor, size: 24.0),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: isHighlight
                      ? const Color(0xFFBA1A1A)
                      : const Color(0xFF7B7488),
                  size: 18.0,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0, // title-md
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.0, // label-sm
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
