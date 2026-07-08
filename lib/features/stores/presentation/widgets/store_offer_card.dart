import 'package:flutter/material.dart';
import '../../domain/entities/store_entities.dart';

class StoreOfferCard extends StatelessWidget {
  final StoreOfferEntity offer;

  const StoreOfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6100D6), Color(0xFF0058BE)], // primary-gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.0), // rounded-3xl
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6100D6).withOpacity(0.2),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background icon blur effect
          Positioned(
            right: -20.0,
            bottom: -20.0,
            child: Icon(
              Icons.sell,
              size: 100.0,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(9999.0), // pill
                ),
                child: Text(
                  offer.tag.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                offer.title,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                offer.description,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.0,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
