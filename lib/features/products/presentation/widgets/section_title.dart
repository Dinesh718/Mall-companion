import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget? customAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // section-title
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
          if (customAction != null)
            customAction!
          else if (actionText != null && onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              child: Row(
                children: [
                  Text(
                    actionText!,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6100D6), // primary
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const Icon(Icons.chevron_right, size: 18.0, color: Color(0xFF6100D6)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
