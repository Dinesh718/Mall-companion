import 'package:flutter/material.dart';
import 'menu_tile.dart';
import 'setting_tile.dart';

class PreferenceCard extends StatelessWidget {
  final String language;
  final bool pushNotificationsEnabled;
  final String accessibility;
  final VoidCallback onLanguageTap;
  final ValueChanged<bool> onNotificationChanged;
  final VoidCallback onAccessibilityTap;

  const PreferenceCard({
    super.key,
    required this.language,
    required this.pushNotificationsEnabled,
    required this.accessibility,
    required this.onLanguageTap,
    required this.onNotificationChanged,
    required this.onAccessibilityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0), // rounded-card
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.2), // outline-variant/20
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Language
          MenuTile(
            leadingIcon: Icons.language,
            title: 'Language',
            trailingText: language,
            showDivider: true,
            onTap: onLanguageTap,
          ),
          // Notifications
          SettingTile(
            leadingIcon: Icons.notifications_active,
            title: 'Push Notifications',
            value: pushNotificationsEnabled,
            onChanged: onNotificationChanged,
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: const Color(0xFFCCC3D9).withOpacity(0.2),
            indent: 20.0,
            endIndent: 20.0,
          ),
          // Accessibility
          MenuTile(
            leadingIcon: Icons.accessibility_new,
            title: 'Accessibility',
            trailingText: accessibility,
            showDivider: false,
            onTap: onAccessibilityTap,
          ),
        ],
      ),
    );
  }
}
