import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(
            leadingIcon,
            color: const Color(0xFF4A4456), // on-surface-variant
            size: 24.0,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16.0, // body-lg
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1A25), // on-surface
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF6100D6), // primary
            inactiveThumbColor: const Color(0xFF7B7488), // outline
            inactiveTrackColor: const Color(0xFFEDE5F5), // surface-container-high
          ),
        ],
      ),
    );
  }
}
