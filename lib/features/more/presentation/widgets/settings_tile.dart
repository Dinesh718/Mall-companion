import 'package:flutter/material.dart';

class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE8DFEF).withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE5F5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: const Color(0xFF6100D6), size: 20.0),
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
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11.0,
                    color: Color(0xFF4A4456),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF6100D6),
            inactiveThumbColor: const Color(0xFF7B7488),
            inactiveTrackColor: const Color(0xFFEDE5F5),
          ),
        ],
      ),
    );
  }
}
