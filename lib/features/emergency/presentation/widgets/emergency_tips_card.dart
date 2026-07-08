import 'package:flutter/material.dart';

class EmergencyTipItem {
  final String text;
  final IconData icon;

  const EmergencyTipItem({required this.text, required this.icon});
}

class EmergencyTipsCard extends StatelessWidget {
  final String sectionTitle;
  final List<EmergencyTipItem> tips;
  final String? quickTipText;

  const EmergencyTipsCard({
    super.key,
    required this.sectionTitle,
    required this.tips,
    this.quickTipText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            sectionTitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tips.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final tip = tips[index];
            return Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF), // bg-surface-container-low
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                children: [
                  Icon(
                    tip.icon,
                    color: const Color(0xFF6100D6),
                    size: 20.0,
                  ), // primary
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      tip.text,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.0, // label-lg/body-md
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (quickTipText != null) ...[
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(
                0xFFFFDCCB,
              ).withOpacity(0.3), // tertiary-container/10
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: const Color(0xFFFFDCCB).withOpacity(0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF813800),
                      size: 18.0,
                    ), // tertiary
                    SizedBox(width: 8.0),
                    Text(
                      'Quick Tip',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF813800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  quickTipText!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    color: Color(0xFF763300), // on-tertiary-fixed-variant
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
