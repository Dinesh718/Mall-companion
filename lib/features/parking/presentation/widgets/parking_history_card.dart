import 'package:flutter/material.dart';
import '../../domain/entities/parking_entities.dart';

class ParkingHistoryCard extends StatelessWidget {
  final ParkingHistoryItemEntity item;
  final VoidCallback? onTap;

  const ParkingHistoryCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0), // rounded-[24px]
          border: Border.all(
            color: const Color(
              0xFFCCC3D9,
            ).withOpacity(0.2), // outline-variant/20
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0), // p-4
        child: Row(
          children: [
            // Left icon container
            Container(
              width: 40.0,
              height: 40.0,
              decoration: const BoxDecoration(
                color: Color(0xFFF9F1FF), // surface-container-low
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF4A4456), // on-surface-variant
                size: 20.0,
              ),
            ),
            const SizedBox(width: 16.0),
            // Details column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.mallName,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0, // body-lg
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${item.dateText} • ${item.zone} (${item.slot}) • ${item.durationText}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0, // label-md
                      color: Color(0xFF4A4456), // on-surface-variant
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF4A4456)),
          ],
        ),
      ),
    );
  }
}
