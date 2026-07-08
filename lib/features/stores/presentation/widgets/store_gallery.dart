import 'package:flutter/material.dart';

class StoreGallery extends StatelessWidget {
  final List<String> imageUrls;
  final double height;

  const StoreGallery({
    super.key,
    required this.imageUrls,
    this.height = 192.0,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final url = imageUrls[index];
          return Container(
            width: 256.0,
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              url,
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
