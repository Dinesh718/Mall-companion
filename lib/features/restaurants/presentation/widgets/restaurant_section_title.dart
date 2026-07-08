import 'package:flutter/material.dart';

class RestaurantSectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const RestaurantSectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
        if (actionText != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
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
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF6100D6),
                  size: 18.0,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
