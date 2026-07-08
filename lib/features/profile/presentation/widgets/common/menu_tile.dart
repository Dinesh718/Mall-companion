import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final bool showDivider;

  const MenuTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.trailingText,
    required this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(
                  leadingIcon,
                  color: const Color(0xFF4A4456), // on-surface-variant
                  size: 24.0,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0, // body-lg
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                  ),
                ),
                if (trailingText != null) ...[
                  Text(
                    trailingText!,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0, // body-md
                      color: Color(0xFF4A4456), // on-surface-variant
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFCCC3D9), // outline-variant
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: const Color(
              0xFFCCC3D9,
            ).withOpacity(0.2), // border-outline-variant/10
            indent: 20.0,
            endIndent: 20.0,
          ),
      ],
    );
  }
}
