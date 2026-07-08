import 'package:flutter/material.dart';
import '../../domain/entities/more_entities.dart';

class MoreShortcutCard extends StatelessWidget {
  final QuickActionEntity action;
  final VoidCallback onTap;

  const MoreShortcutCard({
    super.key,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEmergency = action.type == 'emergency';

    final Color bgColor = isEmergency 
        ? const Color(0xFFFFDAD6).withOpacity(0.3)
        : Colors.white;
    final Border border = isEmergency
        ? Border.all(color: const Color(0xFFBA1A1A).withOpacity(0.15))
        : Border.all(color: const Color(0xFFE8DFEF).withOpacity(0.3));
    final Color iconBgColor = isEmergency
        ? const Color(0xFFFFDAD6)
        : const Color(0xFF7B2FF7).withOpacity(0.1);
    final Color iconColor = isEmergency
        ? const Color(0xFF93000A)
        : const Color(0xFF6100D6);
    final Color titleColor = isEmergency
        ? const Color(0xFFBA1A1A)
        : const Color(0xFF1D1A25);
    final Color descColor = isEmergency
        ? const Color(0xFF93000A).withOpacity(0.7)
        : const Color(0xFF4A4456);
    final Color chevronColor = isEmergency
        ? const Color(0xFFBA1A1A).withOpacity(0.4)
        : const Color(0xFF7B7488).withOpacity(0.5);

    IconData getIconData(String name) {
      switch (name) {
        case 'local_parking':
          return Icons.local_parking_rounded;
        case 'atm':
          return Icons.atm_rounded;
        case 'emergency_share':
          return Icons.emergency_share_rounded;
        default:
          return Icons.grid_view_rounded;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Icon inside wrapper
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14.0),
              ),
              alignment: Alignment.center,
              child: Icon(
                getIconData(action.iconName),
                color: iconColor,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 16.0),
            // Center info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    action.description,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0,
                      color: descColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(
              Icons.chevron_right_rounded,
              color: chevronColor,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
