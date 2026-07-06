import 'package:flutter/material.dart';

class EventBanner extends StatelessWidget {
  final String imageUrl;
  final String statusText;
  final String categoryName;
  final double height;
  final double borderRadius;

  const EventBanner({
    super.key,
    required this.imageUrl,
    required this.statusText,
    required this.categoryName,
    this.height = 144.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final showLive = statusText.toLowerCase() == 'live';
    final showOngoing = statusText.toLowerCase() == 'ongoing';
    final showFeatured = statusText.toLowerCase() == 'featured';

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Event Image background
          Image.network(
            imageUrl,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFEDE5F5),
              alignment: Alignment.center,
              child: const Icon(
                Icons.local_activity_outlined,
                size: 48.0,
                color: Color(0xFF6100D6),
              ),
            ),
          ),
          // Gradient fade on top
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Badges Overlay (Top Left)
          if (showFeatured)
            Positioned(
              top: 12.0,
              left: 12.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF6100D6,
                      ).withOpacity(0.9), // primary
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    child: const Text(
                      'Featured',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600, // label-sm
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600, // label-sm
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (showLive)
            Positioned(
              top: 12.0,
              left: 12.0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A), // error / red
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _LivePulseDot(),
                    const SizedBox(width: 6.0),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (showOngoing)
            Positioned(
              top: 12.0,
              left: 12.0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF6100D6), // primary
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.schedule, size: 12.0, color: Colors.white),
                    SizedBox(width: 4.0),
                    Text(
                      'ONGOING',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LivePulseDot extends StatefulWidget {
  const _LivePulseDot();

  @override
  State<_LivePulseDot> createState() => _LivePulseDotState();
}

class _LivePulseDotState extends State<_LivePulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 6.0,
        height: 6.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
