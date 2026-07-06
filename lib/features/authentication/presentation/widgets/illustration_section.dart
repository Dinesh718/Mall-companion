import 'package:flutter/material.dart';
import 'package:visitor_mall/features/onboarding/presentation/widgets/floating_widget.dart';
import 'package:visitor_mall/features/onboarding/presentation/widgets/glass_card.dart';

class IllustrationSection extends StatelessWidget {
  final String imageUrl;
  final String? badgeEmoji;
  final String? badgeText;

  const IllustrationSection({
    super.key,
    required this.imageUrl,
    this.badgeEmoji,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background Glow Circle
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6100D6).withOpacity(0.05),
              ),
            ),
          ),
          // Main illustration image card
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20.0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFFEFF4FF),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF6100D6),
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFEFF4FF),
                    child: const Center(
                      child: Icon(
                        Icons.local_mall_outlined,
                        color: Color(0xFF6100D6),
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Optional Glass Card Floater
          if (badgeEmoji != null && badgeText != null)
            Positioned(
              bottom: -16.0,
              child: FloatingWidget(
                delayFraction: 0.1,
                offset: 8.0,
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  borderRadius: 999.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(badgeEmoji!, style: const TextStyle(fontSize: 16.0)),
                      const SizedBox(width: 8.0),
                      Text(
                        badgeText!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
