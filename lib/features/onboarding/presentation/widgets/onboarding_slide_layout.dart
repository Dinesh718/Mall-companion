// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'floating_widget.dart';

class OnboardingSlideLayout extends StatelessWidget {
  final int pageIndex;

  const OnboardingSlideLayout({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final isSmallScreen = screenHeight < 680;

        return Column(
          children: [
            // Responsive Illustration Area
            Expanded(
              flex: isSmallScreen ? 5 : 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: _buildIllustration(context, isSmallScreen),
                ),
              ),
            ),
            // Text Area
            Expanded(
              flex: isSmallScreen ? 3 : 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: isSmallScreen
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Text(
                      _getTitle(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 32.0,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        letterSpacing: -0.64,
                        color: Color(0xFF121C2A),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _getDescription(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIllustration(BuildContext context, bool isSmallScreen) {
    switch (pageIndex) {
      case 0:
        return _buildPage1Illustration(isSmallScreen);
      case 1:
        return _buildPage2Illustration(isSmallScreen);
      case 2:
        return _buildPage3Illustration(isSmallScreen);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Slide 1: Navigate Every Corner ---
  Widget _buildPage1Illustration(bool isSmallScreen) {
    const imageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC3wFzxMr2-xiT1IXBjd7U2EfYZ6N40wAYzAQwLJlnYlJEQOz1M9r3sXNfL5hqq4kX8JZVHNHqFy_1jYK3mt9gqFbsWUOPm6-GveDkDbdu-OJsd2vxDLa8xntu5r0uf7J7xDqeADF4s4ajl6fikxuUYcDMhYOAXqTZxyTmdNPCtjpxBuE6ilXUIGMXt_8TjWLVz-AxGnVM4k87o-V6h9w_SDpkKnIcU710HRSKU03dpBQEv7X0fTHHKuZnnGdOs-YDG5v4ZZDTS4Q';

    return SizedBox(
      width: isSmallScreen ? 240 : 280,
      height: isSmallScreen ? 240 : 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Pulse background effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6100D6).withOpacity(0.08),
              ),
            ),
          ),
          // Main Image Card
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 24.0,
                    offset: const Offset(0, 12),
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
                    return _buildImagePlaceholder();
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImageErrorPlaceholder(),
                ),
              ),
            ),
          ),
          // Floating Card 1 (Top-Right): Luxury Hub
          Positioned(
            top: 40.0,
            right: -24.0,
            child: FloatingWidget(
              delayFraction: 0.0,
              offset: 8.0,
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                borderRadius: 12.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7B2FF7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_mall,
                        color: Colors.white,
                        size: 14.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Luxury Hub',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6100D6),
                          ),
                        ),
                        Text(
                          '2 mins walk',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8.0,
                            color: Color(0xFF4A4456),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating Card 2 (Bottom-Left): The Bistro
          Positioned(
            bottom: 60.0,
            left: -28.0,
            child: FloatingWidget(
              delayFraction: 0.25,
              offset: 8.0,
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                borderRadius: 12.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2170E4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 14.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'The Bistro',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0058BE),
                          ),
                        ),
                        Text(
                          'Floor 3',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8.0,
                            color: Color(0xFF4A4456),
                          ),
                        ),
                      ],
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

  // --- Slide 2: Explore More Than Shopping ---
  Widget _buildPage2Illustration(bool isSmallScreen) {
    const imageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuABTJg6uS7zWYZgllqvDWDFH48Y9O3UQG7YRsuYcVYBpFkj41xhXSva8y5CcqGPhxXpqlXWhR-9wd272_xlvux1DzjdvNIIO-A3JEIODgyHXW5pSIqndMzrOJ6gNG4jNDoNBzCYCEZTHwiXRHAmug5FkP-R8xkb4rXYmG-b2rN494nyXV3v8FAt6UNly7CsGynYabhc3QE2RpULZ7fQffst1LsUARn1cnhenLBOX8S42UquIH6X5_6zKlty-DW-WnvBBkfxuECwmQ';

    return SizedBox(
      width: isSmallScreen ? 240 : 280,
      height: isSmallScreen ? 240 : 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Image Card
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
                    return _buildImagePlaceholder();
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImageErrorPlaceholder(),
                ),
              ),
            ),
          ),
          // Gradient fade on image bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          // Floating Label 1: Restaurants
          Positioned(
            top: 20.0,
            left: -20.0,
            child: FloatingWidget(
              delayFraction: 0.0,
              offset: 8.0,
              child: const _EmojiLabel(emoji: '🍔', label: 'Restaurants'),
            ),
          ),
          // Floating Label 2: Offers
          Positioned(
            top: 76.0,
            right: -25.0,
            child: FloatingWidget(
              delayFraction: 0.35,
              offset: 8.0,
              child: const _EmojiLabel(emoji: '🏷', label: 'Offers'),
            ),
          ),
          // Floating Label 3: Events
          Positioned(
            bottom: 100.0,
            left: -15.0,
            child: FloatingWidget(
              delayFraction: 0.2,
              offset: 8.0,
              child: const _EmojiLabel(emoji: '🎉', label: 'Events'),
            ),
          ),
          // Floating Label 4: Entertainment
          Positioned(
            bottom: 60.0,
            right: -10.0,
            child: FloatingWidget(
              delayFraction: 0.5,
              offset: 8.0,
              child: const _EmojiLabel(emoji: '🎬', label: 'Entertainment'),
            ),
          ),
          // Floating Label 5: Kids Zone
          Positioned(
            bottom: -12.0,
            left: 50.0,
            right: 50.0,
            child: FloatingWidget(
              delayFraction: 0.3,
              offset: 6.0,
              child: const Center(
                child: _EmojiLabel(emoji: '🧸', label: 'Kids Zone'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Slide 3: Your Smart Mall Assistant ---
  Widget _buildPage3Illustration(bool isSmallScreen) {
    const imageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAVZ7dudpHg_CtXUxI0DJ1HYxuXRauPrEzUQ5ZUyZAUKc2VtzrPS9JTEPLLOeQuznLR_r5zjZ06PWYzs1c4Y15SPpcDXPJ70pYe8Ru-S25LT-qhcFZJlISXIDGncIA_YswIHHIUC1QeyJeG0U__z4MxXjHEyOrfv7E9hVm9wTYQf6LQ-E_N5dUzGBT-lxsPIb-3EacD-ajS7vWcfbVPseyoH87mCYdkGF1zEWW0O_Zvoac1UiazpoVV4VHkfzE2abyPaXdS9Pr9Hg';

    final phoneWidth = isSmallScreen ? 140.0 : 160.0;
    final phoneHeight = phoneWidth * (18 / 9);

    return SizedBox(
      width: phoneWidth + 80.0, // generous space for floaters
      height: phoneHeight + 40.0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Floating Phone Container
          FloatingWidget(
            offset: 12.0,
            duration: const Duration(seconds: 6),
            child: Container(
              width: phoneWidth,
              height: phoneHeight,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: const Color(0xFF121C2A),
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.24),
                    blurRadius: 28.0,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(23.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23.0),
                  child: Stack(
                    children: [
                      // Inner background screen map image
                      Positioned.fill(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _buildImagePlaceholder();
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageErrorPlaceholder(),
                        ),
                      ),
                      // Overlay UI - Header Search Card
                      Positioned(
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                        height: 24.0,
                        child: GlassCard(
                          borderRadius: 12.0,
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                size: 10.0,
                                color: Color(0xFF6100D6),
                              ),
                              const SizedBox(width: 4.0),
                              Container(
                                width: 50.0,
                                height: 4.0,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4A4456,
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Center Pulsing Pointer Icon
                      Center(
                        child: _PulsingIcon(
                          icon: Icons.navigation,
                          color: const Color(0xFF6100D6),
                          size: isSmallScreen ? 24.0 : 28.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating Icon 1 (Top-Right): Heart
          Positioned(
            top: phoneHeight * 0.18,
            right: 0.0,
            child: FloatingWidget(
              delayFraction: 0.1,
              offset: 8.0,
              child: const _AccentIcon(
                icon: Icons.favorite,
                iconColor: Color(0xFFBA1A1A),
              ),
            ),
          ),
          // Floating Icon 2 (Mid-Left): Parking
          Positioned(
            top: phoneHeight * 0.45,
            left: 0.0,
            child: FloatingWidget(
              delayFraction: 0.3,
              offset: 8.0,
              child: const _AccentIcon(
                icon: Icons.local_parking,
                iconColor: Color(0xFF0058BE),
              ),
            ),
          ),
          // Floating Icon 3 (Bottom-Right): Sparkle
          Positioned(
            bottom: phoneHeight * 0.12,
            right: 8.0,
            child: FloatingWidget(
              delayFraction: 0.5,
              offset: 8.0,
              child: const _AccentIcon(
                icon: Icons.auto_awesome,
                iconColor: Color(0xFF7B2FF7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Placeholders ---
  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFEFF4FF),
      child: const Center(
        child: SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
          ),
        ),
      ),
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: const Color(0xFFEFF4FF),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF7B7488),
          size: 32.0,
        ),
      ),
    );
  }

  // --- Helper Texts ---
  String _getTitle() {
    switch (pageIndex) {
      case 0:
        return 'Navigate Every Corner.';
      case 1:
        return 'Explore More Than Shopping.';
      case 2:
        return 'Your Smart Mall Assistant.';
      default:
        return '';
    }
  }

  String _getDescription() {
    switch (pageIndex) {
      case 0:
        return 'Find any store, restaurant, restroom, ATM, elevator, parking area or facility instantly with intelligent indoor navigation.';
      case 1:
        return 'Discover restaurants, exclusive offers, live events, entertainment, kids zones and every experience inside the mall.';
      case 2:
        return 'Navigate with AR guidance, save your favourite stores, remember parking, receive personalized recommendations and enjoy a smarter shopping experience.';
      default:
        return '';
    }
  }
}

// --- Inner helper widgets ---

class _EmojiLabel extends StatelessWidget {
  final String emoji;
  final String label;

  const _EmojiLabel({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      borderRadius: 9999.0, // fully rounded pill
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16.0)),
          const SizedBox(width: 6.0),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF121C2A),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccentIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  const _AccentIcon({required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12.0),
      borderRadius: 16.0,
      child: Icon(icon, color: iconColor, size: 20.0),
    );
  }
}

class _PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _PulsingIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: RotationTransition(
        turns: const AlwaysStoppedAnimation(
          45 / 360,
        ), // standard tilted navigation pointer
        child: Icon(widget.icon, color: widget.color, size: widget.size),
      ),
    );
  }
}
