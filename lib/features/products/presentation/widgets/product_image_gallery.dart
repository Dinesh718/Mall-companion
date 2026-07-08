import 'package:flutter/material.dart';

class ProductImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final ValueChanged<String>? onImageSelected;

  const ProductImageGallery({
    super.key,
    required this.imageUrls,
    this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 140.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final url = imageUrls[index];
          return GestureDetector(
            onTap: () {
              if (onImageSelected != null) {
                onImageSelected!(url);
              }
            },
            child: Container(
              width: 140.0,
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
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
            ),
          );
        },
      ),
    );
  }
}
