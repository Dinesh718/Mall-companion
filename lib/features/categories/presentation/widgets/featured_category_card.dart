import 'package:flutter/material.dart';

class FeaturedCategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String tag;
  final String imageUrl;
  final VoidCallback onExploreTap;

  const FeaturedCategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.tag,
    required this.imageUrl,
    required this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0), // rounded-[24px]
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF6100D6),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.campaign,
                      color: Colors.white,
                      size: 64.0,
                    ),
                  ),
                ),
              ),
              // Dark Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              // Text Content & CTA Button
              Positioned(
                bottom: 24.0,
                left: 24.0,
                right: 24.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14.0,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16.0),
                    // Explore Button
                    GestureDetector(
                      onTap: onExploreTap,
                      child: Container(
                        height: 48.0,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9999.0),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        width: 140.0,
                        child: const Text(
                          'Explore',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
