import 'package:flutter/material.dart';

class RestaurantWaitingTimeChip extends StatelessWidget {
  final String waitTimeText;

  const RestaurantWaitingTimeChip({super.key, required this.waitTimeText});

  @override
  Widget build(BuildContext context) {
    final isDirectSeating = waitTimeText.toLowerCase() == 'open';

    return Container(
      decoration: BoxDecoration(
        color: isDirectSeating
            ? const Color(0xFFF0FDF4) // green-50
            : const Color(0xFFFFDBCA).withOpacity(0.4), // tertiary-fixed/40
        borderRadius: BorderRadius.circular(100.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDirectSeating ? Icons.check_circle : Icons.schedule,
            size: 14.0,
            color: isDirectSeating
                ? const Color(0xFF16A34A)
                : const Color(0xFF813800),
          ),
          const SizedBox(width: 4.0),
          Text(
            isDirectSeating ? 'Direct Seating' : 'Wait: $waitTimeText',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
              color: isDirectSeating
                  ? const Color(0xFF16A34A)
                  : const Color(0xFF813800),
            ),
          ),
        ],
      ),
    );
  }
}
