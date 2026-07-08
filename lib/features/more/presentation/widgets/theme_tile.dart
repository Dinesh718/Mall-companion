import 'package:flutter/material.dart';

class ThemeSelectorTile extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onThemeChanged;

  const ThemeSelectorTile({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE8DFEF).withOpacity(0.3),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE5F5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.palette_rounded,
                  color: const Color(0xFF6100D6),
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 16.0),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      'Select dark, light, or auto theme mode',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11.0,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: ['Light', 'Dark', 'System'].map((mode) {
              final isSelected = selectedTheme == mode;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(mode),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) onThemeChanged(mode);
                    },
                    selectedColor: const Color(0xFF6100D6),
                    backgroundColor: const Color(0xFFF9F1FF),
                    labelStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF4A4456),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF6100D6) : const Color(0xFFEDE5F5),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
