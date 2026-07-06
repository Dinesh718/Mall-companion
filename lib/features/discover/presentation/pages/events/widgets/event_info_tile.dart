import 'package:flutter/material.dart';

class EventInfoTile extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;

  const EventInfoTile({
    super.key,
    required this.iconData,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3EBFA), // surface-container
        borderRadius: BorderRadius.circular(16.0), // rounded-2xl
      ),
      padding: const EdgeInsets.all(12.0), // p-3
      child: Row(
        children: [
          Icon(
            iconData,
            color: const Color(0xFF6100D6), // primary
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0, // text-label-sm
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7B7488), // outline
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600, // label-lg
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
