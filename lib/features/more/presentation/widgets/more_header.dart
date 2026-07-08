import 'package:flutter/material.dart';

class MoreHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String avatarUrl;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onProfileTap;

  const MoreHeader({
    super.key,
    required this.title,
    required this.avatarUrl,
    required this.onMenuTap,
    required this.onNotificationsTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF6100D6)),
                    onPressed: onMenuTap,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF4A4456),
                    ),
                    onPressed: onNotificationsTap,
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEDE5F5),
                          width: 1.0,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                          onError: (_, __) {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}
