import 'package:flutter/material.dart';
import '../../domain/entities/store_entities.dart';
import 'store_logo.dart';

class StoreCard extends StatelessWidget {
  final StoreEntity store;
  final VoidCallback onTap;
  final VoidCallback onNavigate;
  final bool isFeaturedLayout;

  const StoreCard.featured({
    super.key,
    required this.store,
    required this.onTap,
    required this.onNavigate,
  }) : isFeaturedLayout = true;

  const StoreCard.list({
    super.key,
    required this.store,
    required this.onTap,
    required this.onNavigate,
  }) : isFeaturedLayout = false;

  @override
  Widget build(BuildContext context) {
    if (isFeaturedLayout) {
      return _buildFeaturedCard(context);
    }
    return _buildListCard(context);
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-3xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Banner Image + Status / Logo overlay
          Stack(
            children: [
              SizedBox(
                height: 176.0,
                width: double.infinity,
                child: Image.network(
                  store.bannerUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                ),
              ),
              // Open status badge top left
              Positioned(
                top: 16.0,
                left: 16.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(9999.0), // pill
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: store.isOpen ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        store.isOpen ? 'Open Now' : 'Closed',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1A25), // on-surface
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Logo, Name and Location at the bottom of banner
              Positioned(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                child: Row(
                  children: [
                    StoreLogo(logoUrl: store.logoUrl, size: 48.0, padding: 4.0),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 1),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            store.locationText,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 1),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Action Buttons: View Details & Navigate
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: const Color(0xFFCCC3D9)), // outline-variant
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'View Store',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6100D6), // primary
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: GestureDetector(
                    onTap: onNavigate,
                    child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)], // primary-gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B2FF7).withOpacity(0.2),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.near_me, color: Colors.white, size: 16.0),
                          SizedBox(width: 6.0),
                          Text(
                            'Navigate',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0, left: 20.0, right: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0), // rounded-[32px]
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.3), // outline-variant/30
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Banner image
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 110.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          store.bannerUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                        ),
                      ),
                      // Brand logo overlaid on top left of banner
                      Positioned(
                        top: 10.0,
                        left: 10.0,
                        child: StoreLogo(logoUrl: store.logoUrl, size: 40.0, padding: 3.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // Right: Details column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Rating row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            store.name,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 18.0, // card-title
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1A25), // on-surface
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EBFA), // surface-container
                            borderRadius: BorderRadius.circular(9999.0), // pill
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 12.0),
                              const SizedBox(width: 4.0),
                              Text(
                                store.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D1A25),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),

                    // Category text
                    Text(
                      store.category,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13.0,
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12.0),

                    // Specifications
                    Row(
                      children: [
                        const Icon(Icons.layers, size: 16.0, color: Color(0xFF4A4456)),
                        const SizedBox(width: 6.0),
                        Text(
                          store.floorText,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.0,
                            color: Color(0xFF4A4456),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16.0, color: Color(0xFF22C55E)),
                        const SizedBox(width: 6.0),
                        Text(
                          'Open (${store.openingHours})',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF22C55E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        const Icon(Icons.directions_walk, size: 16.0, color: Color(0xFF4A4456)),
                        const SizedBox(width: 6.0),
                        Text(
                          store.distanceWalkText,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.0,
                            color: Color(0xFF4A4456),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          // Actions below
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F1FF), // surface-container-low
                      borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                      border: Border.all(
                        color: const Color(0xFF6100D6).withOpacity(0.1),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Details',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              GestureDetector(
                onTap: onNavigate,
                child: Container(
                  width: 56.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)], // primary-gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B2FF7).withOpacity(0.2),
                        blurRadius: 8.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.near_me, color: Colors.white, size: 18.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
