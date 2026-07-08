import 'package:flutter/material.dart';
import '../../domain/entities/product_entities.dart';

class ProductInformationCard extends StatefulWidget {
  final ProductEntity product;

  const ProductInformationCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductInformationCard> createState() => _ProductInformationCardState();
}

class _ProductInformationCardState extends State<ProductInformationCard> {
  String? _selectedColor;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    if (widget.product.availableColors.isNotEmpty) {
      _selectedColor = widget.product.availableColors.first;
    }
    if (widget.product.availableSizes.isNotEmpty) {
      _selectedSize = widget.product.availableSizes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available Colors
          if (product.availableColors.isNotEmpty) ...[
            const Text(
              'Colors',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1A25),
              ),
            ),
            const SizedBox(height: 12.0),
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              children: product.availableColors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6100D6) : const Color(0xFFF3EBFA),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      color,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF4A4456),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24.0),
          ],

          // Available Sizes
          if (product.availableSizes.isNotEmpty) ...[
            const Text(
              'Size',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1A25),
              ),
            ),
            const SizedBox(height: 12.0),
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              children: product.availableSizes.map((size) {
                final isSelected = _selectedSize == size;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSize = size;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6100D6) : const Color(0xFFF3EBFA),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF4A4456),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
