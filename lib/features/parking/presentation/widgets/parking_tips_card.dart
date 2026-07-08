import 'package:flutter/material.dart';

class ParkingTipsCard extends StatelessWidget {
  final String title;
  final String tipText;
  final IconData icon;

  const ParkingTipsCard({
    super.key,
    this.title = 'Pro Tip',
    required this.tipText,
    this.icon = Icons.lightbulb_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1FF), // surface-container-low
        borderRadius: BorderRadius.circular(24.0), // rounded-[24px]
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.3), // outline-variant/30
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(20.0), // p-5
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF0058BE), // secondary
                size: 24.0,
              ),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16.0, // title-lg
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0058BE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            tipText,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0, // body-md
              color: Color(0xFF4A4456), // on-surface-variant
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
