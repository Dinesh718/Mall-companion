import 'package:flutter/material.dart';

class EmergencyLoadingSkeleton extends StatelessWidget {
  const EmergencyLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulated title pulse
          _buildPulseContainer(width: 120.0, height: 24.0),
          const SizedBox(height: 16.0),
          // Simulated hero card pulse
          _buildPulseContainer(width: double.infinity, height: 180.0),
          const SizedBox(height: 24.0),
          // Bento item pulse grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
            children: List.generate(
              4,
              (index) =>
                  _buildPulseContainer(width: double.infinity, height: 100.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseContainer({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFD3E4FE).withOpacity(0.4), // surface-variant
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}

class EmergencyEmptyState extends StatelessWidget {
  final String title;
  final String description;

  const EmergencyEmptyState({
    super.key,
    this.title = 'No facilities found',
    this.description = 'We couldn\'t locate any nearby emergency facilities.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: const Color(0xFF6100D6).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off,
                color: Color(0xFF6100D6),
                size: 40.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1A25),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.0,
                color: Color(0xFF4A4456),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const EmergencyErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDAD6), // error-container
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: const Color(0xFFBA1A1A).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFBA1A1A),
                    size: 24.0,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: Color(0xFF93000A), // on-error-container
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6100D6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
