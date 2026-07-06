import 'package:flutter/material.dart';

class EventHostCard extends StatelessWidget {
  final String hostName;
  final String hostLogoUrl;
  final String role;

  const EventHostCard({
    super.key,
    required this.hostName,
    required this.hostLogoUrl,
    this.role = 'Organizer',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-3xl
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.2), // outline-variant/20
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Host Logo circular avatar
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEDE5F5), // surface-container-high
              border: Border.all(
                color: const Color(0xFFCCC3D9).withOpacity(0.3),
                width: 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: hostLogoUrl.isNotEmpty
                  ? Image.network(
                      hostLogoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.business, color: Color(0xFF6100D6)),
                    )
                  : const Icon(Icons.business, color: Color(0xFF6100D6)),
            ),
          ),
          const SizedBox(width: 16.0),
          // Host Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  role,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0, // label-sm
                    fontWeight: FontWeight.w500,
                    color: const Color(
                      0xFF4A4456,
                    ).withOpacity(0.6), // on-surface-variant/60
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  hostName,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600, // headline-sm/label-lg
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
              ],
            ),
          ),
          // Contact Button
          IconButton(
            onPressed: () {
              // Open organizer contact method
            },
            icon: const Icon(
              Icons.mail_outline_rounded,
              color: Color(0xFF6100D6),
            ),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF9F1FF),
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
