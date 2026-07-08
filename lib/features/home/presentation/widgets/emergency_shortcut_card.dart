import 'package:flutter/material.dart';
import '../../domain/entities/home_entities.dart';
import '../../../emergency/presentation/pages/emergency_hub_page.dart';

class EmergencyShortcutCard extends StatelessWidget {
  final EmergencyShortcutEntity emergency;

  const EmergencyShortcutCard({super.key, required this.emergency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2), // bg-red-50
          borderRadius: BorderRadius.circular(24.0), // rounded-3xl
          border: Border.all(
            color: const Color(0xFFFEE2E2), // border-red-100
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withOpacity(0.04),
              blurRadius: 15.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emergency Bell/Exclamation Circle Icon
            Container(
              width: 40.0,
              height: 40.0,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2), // bg-red-100
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emergency_outlined,
                color: Color(0xFFDC2626), // red-600
                size: 20.0,
              ),
            ),
            const SizedBox(width: 12.0),
            // Text labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emergency.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7F1D1D), // red-900
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    emergency.subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF991B1B), // red-800
                    ),
                  ),
                ],
              ),
            ),
            // Action button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmergencyHubPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626), // red-600
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0), // rounded-full
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                elevation: 2.0,
                shadowColor: const Color(0xFFDC2626).withOpacity(0.24),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Emergency Hub',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
