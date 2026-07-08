import 'package:flutter/material.dart';

class PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String> onPrioritySelected;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = ['Low', 'Medium', 'High', 'Urgent'];

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: options.map((priority) {
        final isSelected = priority == selectedPriority;

        Color borderColor;
        Color backgroundColor;
        Color textColor;
        FontWeight fontWeight;
        double borderWidth;

        if (priority == 'Urgent') {
          borderColor = const Color(0xFFBA1A1A); // error
          backgroundColor = isSelected ? const Color(0xFFFFDAD6) : Colors.white;
          textColor = const Color(0xFFBA1A1A);
          fontWeight = isSelected ? FontWeight.bold : FontWeight.w500;
          borderWidth = isSelected ? 2.0 : 1.0;
        } else {
          borderColor = isSelected ? const Color(0xFF6100D6) : const Color(0xFFCCC3D9); // primary : outline-variant
          backgroundColor = isSelected ? const Color(0xFFEADDFF) : Colors.white; // primary-fixed : white
          textColor = isSelected ? const Color(0xFF6100D6) : const Color(0xFF4A4456); // primary : on-surface-variant
          fontWeight = isSelected ? FontWeight.bold : FontWeight.w500;
          borderWidth = isSelected ? 2.0 : 1.0;
        }

        return GestureDetector(
          onTap: () => onPrioritySelected(priority),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(9999.0), // rounded-full
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            child: Text(
              priority,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
