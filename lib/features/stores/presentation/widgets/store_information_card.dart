import 'package:flutter/material.dart';
import '../../domain/entities/store_entities.dart';

class StoreInformationCard extends StatelessWidget {
  final StoreEntity store;

  const StoreInformationCard({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // Floor Location Box
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F1FF), // surface-container-low
                borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF6100D6)), // primary
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.locationText,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0, // label-sm
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4456), // on-surface-variant
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          store.storeNumber,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10.0,
                            color: Color(0xFF7B7488), // outline
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12.0),

          // Timings Box
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F1FF), // surface-container-low
                borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Color(0xFF6100D6)), // primary
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.openingHours,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0, // label-sm
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4456), // on-surface-variant
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          store.isOpen ? 'Open Now' : 'Closed',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6100D6), // primary
                          ),
                        ),
                      ],
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
