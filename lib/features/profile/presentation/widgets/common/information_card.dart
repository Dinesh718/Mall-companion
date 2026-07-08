import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  final String versionText;
  final String? subtitle;
  final bool showLogoAndCallIcon;

  const InformationCard({
    super.key,
    required this.versionText,
    this.subtitle,
    this.showLogoAndCallIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showLogoAndCallIcon) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE8DFEF), // bg-surface-container-highest
                borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              ),
              child: const Icon(
                Icons.call,
                color: Color(0xFF4A4456), // on-surface-variant
                size: 24.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Mall Companion',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 20.0, // title-lg
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1A25), // on-surface
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              versionText,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.0, // label-lg
                color: Color(0xFF4A4456), // on-surface-variant
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              versionText,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11.0, // label-md
                color: const Color(
                  0xFF4A4456,
                ).withOpacity(0.6), // on-surface-variant opacity-60
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4.0),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11.0, // label-md
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4456),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }
}
