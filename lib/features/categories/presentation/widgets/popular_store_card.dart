import 'package:flutter/material.dart';
import '../../domain/entities/category_entities.dart';

class PopularStoreCard extends StatelessWidget {
  final CategoryStoreEntity store;
  final VoidCallback onNavigateTap;

  const PopularStoreCard({
    super.key,
    required this.store,
    required this.onNavigateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // bg-surface-container-lowest
        borderRadius: BorderRadius.circular(16.0), // rounded-2xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Store Logo Box
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: store.logoUrl == 'ZARA' ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(12.0), // rounded-xl
              border: store.logoUrl == 'ZARA'
                  ? Border.all(color: const Color(0xFFCCC3D9), width: 1.0)
                  : null,
            ),
            padding: const EdgeInsets.all(6.0),
            alignment: Alignment.center,
            child: _buildLogoWidget(store.logoUrl),
          ),
          const SizedBox(width: 16.0),
          // Store Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  store.name,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16.0, // card-title
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(
                      Icons.layers,
                      size: 14.0,
                      color: Color(0xFF4A4456), // on-surface-variant
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      store.floorText,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                // Open status badge
                Row(
                  children: [
                    Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: store.isOpen ? const Color(0xFF059669) : const Color(0xFFDC2626), // emerald-600 or red-600
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      store.isOpen ? 'Open Now' : 'Closed',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: store.isOpen ? const Color(0xFF059669) : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Navigate Button
          GestureDetector(
            onTap: onNavigateTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEADDFF), // bg-primary-fixed
                borderRadius: BorderRadius.circular(12.0), // rounded-xl
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.near_me,
                    size: 16.0,
                    color: Color(0xFF25005A), // on-primary-fixed
                  ),
                  SizedBox(width: 6.0),
                  Text(
                    'Navigate',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25005A),
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

  Widget _buildLogoWidget(String logoUrl) {
    if (logoUrl == 'SAINT LAURENT') {
      return const Text(
        'SAINT LAURENT',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: Colors.white,
          fontSize: 8.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    } else if (logoUrl == 'ZARA') {
      return const Text(
        'ZARA',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      );
    } else if (logoUrl == 'NIKE') {
      return const Icon(
        Icons.check_circle,
        color: Colors.white,
        size: 32.0,
      );
    } else {
      return Text(
        logoUrl,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}
