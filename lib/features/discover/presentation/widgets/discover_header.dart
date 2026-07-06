import 'package:flutter/material.dart';

class DiscoverHeader extends StatelessWidget {
  final String avatarUrl;

  const DiscoverHeader({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting / Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Discover',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  'Find everything inside the mall',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  // Notification Hub Action
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF4A4456),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFF9F1FF,
                  ), // surface-container-low
                  minimumSize: const Size(40.0, 40.0),
                  shape: const CircleBorder(),
                ),
                splashRadius: 20.0,
              ),
              const SizedBox(width: 12.0),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(
                      0xFF7B2FF7,
                    ).withOpacity(0.2), // primary-container/20
                    width: 2.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.person, color: Color(0xFF4A4456)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
