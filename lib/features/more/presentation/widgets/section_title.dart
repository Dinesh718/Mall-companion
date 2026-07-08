import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onActionTap;
  final String? actionText;

  const SectionTitle({
    super.key,
    required this.title,
    this.onActionTap,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1A25),
          ),
        ),
        if (onActionTap != null && actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6100D6),
              ),
            ),
          ),
      ],
    );
  }
}
