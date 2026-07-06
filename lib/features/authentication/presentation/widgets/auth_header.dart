import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBackPress;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onBackPress != null) ...[
          IconButton(
            onPressed: onBackPress,
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF1F2937),
              size: 24.0,
            ),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            constraints: const BoxConstraints(),
            splashRadius: 20.0,
          ),
          const SizedBox(height: 20.0),
        ],
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 28.0,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.56,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            height: 1.45,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
