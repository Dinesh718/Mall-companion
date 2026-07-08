import 'package:flutter/material.dart';

class RestaurantGallery extends StatelessWidget {
  final List<String> imageUrls;

  const RestaurantGallery({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            width: 140.0,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: const Color(0xFFEDE5F5),
                width: 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFEDE5F5),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  color: Color(0xFF6100D6),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
