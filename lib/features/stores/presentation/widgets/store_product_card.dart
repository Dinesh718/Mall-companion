import 'package:flutter/material.dart';
import '../../domain/entities/store_entities.dart';

class StoreProductCard extends StatelessWidget {
  final ProductEntity product;

  const StoreProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.0,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0), // rounded-2xl
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.3), // outline-variant/30
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SizedBox(
            height: 192.0,
            width: double.infinity,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFEDE5F5),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF6100D6),
                ),
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0, // label-sm
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10.0,
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
  }
}
