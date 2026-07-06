import 'package:flutter/material.dart';
import '../../domain/entities/discover_entities.dart';

class CategoryGrid extends StatelessWidget {
  final List<DiscoverCategoryEntity> categories;
  final String selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'sell':
        return Icons.sell;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'category':
        return Icons.category;
      case 'restaurant':
        return Icons.restaurant;
      case 'movie':
        return Icons.movie;
      case 'event':
        return Icons.event;
      case 'grid_view':
        return Icons.grid_view;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 12.0,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryId == category.id;

          final color = Color(int.parse(category.colorHex));
          final bgColor = Color(int.parse(category.bgHex));

          return GestureDetector(
            onTap: () => onCategorySelected(category.id),
            child: Column(
              children: [
                // Icon Box
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.25) : bgColor,
                    borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4.0,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _getIconData(category.iconName),
                    color: isSelected ? color : color,
                    size: 28.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Text label
                Text(
                  category.title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.w500, // label-sm
                    color: isSelected
                        ? const Color(0xFF6100D6)
                        : const Color(0xFF4A4456), // on-surface-variant
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
