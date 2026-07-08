import 'package:flutter/material.dart';
import '../../domain/entities/more_entities.dart';

class PopularServicesSection extends StatelessWidget {
  final List<PopularServiceEntity> popularServices;
  final Function(PopularServiceEntity) onItemTap;

  const PopularServicesSection({
    super.key,
    required this.popularServices,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData getIconData(String name) {
      switch (name) {
        case 'wifi':
          return Icons.wifi_rounded;
        case 'child_care':
          return Icons.child_care_rounded;
        case 'electric_car':
          return Icons.electric_car_rounded;
        case 'luggage':
          return Icons.luggage_rounded;
        default:
          return Icons.grid_view_rounded;
      }
    }

    return SizedBox(
      height: 152.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: popularServices.length,
        itemBuilder: (context, index) {
          final item = popularServices[index];
          return GestureDetector(
            onTap: () => onItemTap(item),
            child: Container(
              width: 140.0,
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular Icon container
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9F1FF), // surface-container-low
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      getIconData(item.iconName),
                      color: const Color(0xFF6100D6), // primary
                      size: 24.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10.0,
                      color: Color(0xFF4A4456),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
