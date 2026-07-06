import 'package:flutter/material.dart';
import '../../domain/entities/discover_entities.dart';

class PopularStores extends StatelessWidget {
  final List<DiscoverStoreEntity> stores;

  const PopularStores({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title & See All Action
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Stores',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600, // headline-md
                  color: Color(0xFF1D1A25), // on-surface
                ),
              ),
              TextButton(
                onPressed: () {
                  // See all action
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600, // label-lg
                    color: Color(0xFF6100D6), // primary
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        // Horizontal list of stores
        SizedBox(
          height: 236.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return Container(
                width: 256.0,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // surface-container-lowest
                  borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15.0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with Rating Badge Overlay
                    Stack(
                      children: [
                        Image.network(
                          store.imageUrl,
                          height: 140.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 140.0,
                            color: const Color(0xFFEDE5F5),
                            child: const Icon(
                              Icons.storefront_outlined,
                              size: 40.0,
                              color: Color(0xFF6100D6),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12.0,
                          left: 12.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ), // rounded-lg (8px)
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4.0,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14.0,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  store.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600, // label-sm
                                    color: Color(0xFF1D1A25), // on-surface
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Details Container
                    Padding(
                      padding: const EdgeInsets.all(16.0), // card-padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600, // label-lg
                              color: Color(0xFF1D1A25),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            '${store.category} • ${store.floorText}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400, // body-md
                              color: Color(0xFF4A4456), // on-surface-variant
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
