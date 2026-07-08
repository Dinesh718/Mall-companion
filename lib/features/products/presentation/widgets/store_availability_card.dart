import 'package:flutter/material.dart';
import '../../domain/entities/product_entities.dart';

class StoreAvailabilityCard extends StatelessWidget {
  final StoreAvailabilityEntity availability;
  final VoidCallback? onTap;

  const StoreAvailabilityCard({
    super.key,
    required this.availability,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EBFA), // surface-container
            borderRadius: BorderRadius.circular(16.0), // rounded-2xl
          ),
          child: Row(
            children: [
              // Store Logo container
              Container(
                width: 64.0,
                height: 64.0,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color(0xFFCCC3D9).withAlpha(76),
                  ),
                ),
                child: Image.network(
                  availability.logoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.store, color: Color(0xFF6100D6)),
                ),
              ),
              const SizedBox(width: 16.0),

              // Detail Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          availability.storeName,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25),
                          ),
                        ),
                        Text(
                          availability.locationText,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0058BE), // secondary
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16.0, color: Color(0xFF4A4456)),
                        const SizedBox(width: 4.0),
                        Text(
                          availability.openingHours,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            color: Color(0xFF4A4456),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        const Icon(Icons.near_me, size: 16.0, color: Color(0xFF4A4456)),
                        const SizedBox(width: 4.0),
                        Text(
                          availability.distanceText,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
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
        ),
      ),
    );
  }
}
