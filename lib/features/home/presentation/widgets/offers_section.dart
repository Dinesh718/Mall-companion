import 'package:flutter/material.dart';
import '../../domain/entities/home_entities.dart';

class OffersSection extends StatelessWidget {
  final List<OfferEntity> offers;

  const OffersSection({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Today\'s Offers',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                  SizedBox(width: 6.0),
                  Text('🔥', style: TextStyle(fontSize: 20.0)),
                ],
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
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 144.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              // Zara has red distance indicator, Max has green in the design
              final isEven = index % 2 == 0;
              final indicatorColor = isEven
                  ? const Color(0xFFBA1A1A)
                  : const Color(0xFF16A34A);

              return Container(
                width: 256.0,
                margin: const EdgeInsets.only(right: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0), // rounded-3xl
                  border: Border.all(
                    color: const Color(0xFFCCC3D9).withOpacity(0.2),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand logo / header
                    SizedBox(
                      height: 24.0,
                      child: Image.network(
                        offer.storeLogoUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Text(
                          offer.storeName,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D1A25),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      offer.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1A25),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      offer.subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0x994A4456), // on-surface-variant/60
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14.0,
                          color: indicatorColor,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          offer.distanceText,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: indicatorColor,
                          ),
                        ),
                      ],
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
