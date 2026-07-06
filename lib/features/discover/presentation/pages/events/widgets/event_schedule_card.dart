import 'package:flutter/material.dart';

class EventScheduleCard extends StatelessWidget {
  final String time;
  final String title;
  final bool isLive;
  final bool isLast;

  const EventScheduleCard({
    super.key,
    required this.time,
    required this.title,
    this.isLive = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Dot & Line Columns
        Column(
          children: [
            if (isLive)
              Container(
                width: 16.0,
                height: 16.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF6100D6), // primary
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
              Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFCCC3D9), // outline-variant
                    width: 2.0,
                  ),
                ),
              ),
            if (!isLast)
              Container(
                width: 2.0,
                height: 48.0,
                color: const Color(
                  0xFFCCC3D9,
                ).withOpacity(0.5), // outline-variant/50
              ),
          ],
        ),
        const SizedBox(width: 16.0),
        // Content details
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLive ? '$time • LIVE NOW' : time,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0, // label-sm
                    fontWeight: isLive ? FontWeight.bold : FontWeight.w500,
                    color: isLive
                        ? const Color(0xFF6100D6)
                        : const Color(0xFF7B7488), // primary / outline
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600, // label-lg
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
