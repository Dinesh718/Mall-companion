import 'package:flutter/material.dart';
import '../../domain/entities/discover_entities.dart';

class NearbyAmenities extends StatelessWidget {
  final List<DiscoverAmenityEntity> amenities;

  const NearbyAmenities({super.key, required this.amenities});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wc':
        return Icons.wc_outlined;
      case 'atm':
        return Icons.atm;
      case 'elevator':
        return Icons.elevator_outlined;
      case 'stairs':
        return Icons.stairs_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Nearby Amenities',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.0,
              fontWeight: FontWeight.w600, // headline-md
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        // Horizontal list of amenities
        SizedBox(
          height: 104.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: amenities.length,
            itemBuilder: (context, index) {
              final amenity = amenities[index];
              return Container(
                width: 112.0,
                margin: const EdgeInsets.only(right: 12.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                  border: Border.all(
                    color: const Color(
                      0xFFCCC3D9,
                    ).withOpacity(0.2), // outline-variant/10
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconData(amenity.iconName),
                      color: const Color(0xFF4A4456).withOpacity(0.7),
                      size: 26.0,
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      amenity.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1A25),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      amenity.distanceText,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4A4456).withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
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
