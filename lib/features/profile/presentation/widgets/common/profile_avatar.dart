import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String avatarUrl;
  final bool isVerified;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    this.isVerified = false,
    this.radius = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Circular Avatar Container with Border
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20.0,
                offset: const Offset(0, 4),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(avatarUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Verified Badge Icon bottom right
        if (isVerified)
          Positioned(
            bottom: 2.0,
            right: 2.0,
            child: Container(
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: const Color(0xFF6100D6), // primary
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4.0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.verified,
                color: Colors.white,
                size: 16.0,
              ),
            ),
          ),
      ],
    );
  }
}
