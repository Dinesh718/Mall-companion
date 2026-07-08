import 'package:flutter/material.dart';
import '../../domain/entities/store_entities.dart';

class StoreContactCard extends StatelessWidget {
  final StoreEntity store;

  const StoreContactCard({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: const Color(0xFFCCC3D9).withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.phone_outlined, color: Color(0xFF6100D6), size: 20.0),
                const SizedBox(width: 12.0),
                Text(
                  store.phone,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1A25),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(Icons.language_outlined, color: Color(0xFF6100D6), size: 20.0),
                const SizedBox(width: 12.0),
                Text(
                  store.website,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1A25),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
