import 'package:flutter/material.dart';

class EmergencyHeroCard extends StatelessWidget {
  final String title;
  final String description;
  final String badgeText;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  const EmergencyHeroCard({
    super.key,
    required this.title,
    required this.description,
    required this.badgeText,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7B2FF7),
            Color(0xFF3B82F6),
          ], // primary to secondary
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background blurry circles
          Positioned(
            right: -48.0,
            top: -48.0,
            child: Container(
              width: 256.0,
              height: 256.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Floating Glass Shield Illustration on the right
          Positioned(
            right: -20.0,
            bottom: -20.0,
            child: Opacity(
              opacity: 0.35,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDurHZSYBv7ZWubZkmaAIVTvZ-gJku-FsNkSPiLM2jyhyYNX2HokImn_Z_NoYq5sAjGto6xZD3QmvIGUIBPIGcRRocEUwW7YghklS3i7ivjruOrSHdWdLyRq1chThTz58CjNMdf4jW1DgtW3igEsk20jKeSajm5HT43mJMlkOt9s1wMRABCJcFgtdfq7efcq5Zg86Cmt8J8bY0uneckRP854ogc-zETeZTxHEghjN7xNf1uwlt5bQjC8lK6Lra-n5w_54PUaGfXXg',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Online Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(9999.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ADE80), // green-400
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        badgeText,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28.0, // headline-lg-mobile
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8.0),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240.0),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Action Buttons
                Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: [
                    ElevatedButton(
                      onPressed: onPrimaryTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF7B2FF7),
                        elevation: 4.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 14.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999.0),
                        ),
                      ),
                      child: Text(
                        primaryButtonText,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: onSecondaryTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.0,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 14.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999.0),
                        ),
                      ),
                      child: Text(
                        secondaryButtonText,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
