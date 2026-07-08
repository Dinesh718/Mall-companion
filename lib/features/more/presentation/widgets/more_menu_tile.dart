import 'package:flutter/material.dart';
import '../../domain/entities/more_entities.dart';

class MallServiceBentoCard extends StatelessWidget {
  final MallServiceEntity service;
  final bool isLarge;
  final VoidCallback onTap;

  const MallServiceBentoCard({
    super.key,
    required this.service,
    this.isLarge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getIconColor(String id) {
      switch (id) {
        case 'directory':
          return const Color(0xFF6100D6); // primary
        case 'parking_availability':
          return const Color(0xFF0058BE); // secondary
        case 'amenities_dir':
          return const Color(0xFF813800); // tertiary
        case 'offers_hub':
          return const Color(0xFF6100D6); // primary
        case 'gift_cards':
          return const Color(0xFF0058BE); // secondary
        default:
          return const Color(0xFF6100D6);
      }
    }

    IconData getIconData(String name) {
      switch (name) {
        case 'map':
          return Icons.map_rounded;
        case 'local_parking':
          return Icons.local_parking_rounded;
        case 'wash':
          return Icons.wash_rounded;
        case 'sell':
          return Icons.sell_rounded;
        case 'card_giftcard':
          return Icons.card_giftcard_rounded;
        default:
          return Icons.grid_view_rounded;
      }
    }

    if (isLarge) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15.0,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: const Color(0xFFE8DFEF).withOpacity(0.3),
            ),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Stack(
            children: [
              // Bottom Right Large Ghost Icon
              Positioned(
                bottom: -20.0,
                right: -20.0,
                child: Icon(
                  Icons.grid_view_rounded,
                  size: 140.0,
                  color: const Color(0xFF6100D6).withOpacity(0.03),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    getIconData(service.iconName),
                    color: getIconColor(service.id),
                    size: 36.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    service.description,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Map',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: getIconColor(service.id),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14.0,
                        color: getIconColor(service.id),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15.0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFE8DFEF).withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              getIconData(service.iconName),
              color: getIconColor(service.id),
              size: 26.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              service.title,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1A25),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              service.description,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11.0,
                color: Color(0xFF4A4456),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
