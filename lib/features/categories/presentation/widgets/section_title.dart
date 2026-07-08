import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget? customAction;
  final double horizontalPadding;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.customAction,
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
          if (customAction != null)
            customAction!
          else if (actionText != null && onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6100D6), // primary
                ),
              ),
            ),
        ],
      ),
    );
  }
}
