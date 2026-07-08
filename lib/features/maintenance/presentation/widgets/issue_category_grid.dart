import 'package:flutter/material.dart';

class IssueCategory {
  final String name;
  final IconData icon;
  final String desc;

  const IssueCategory({
    required this.name,
    required this.icon,
    required this.desc,
  });
}

class IssueCategoryGrid extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const IssueCategoryGrid({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<IssueCategory> categories = [
    IssueCategory(
      name: 'Cleaning',
      icon: Icons.cleaning_services_outlined,
      desc: 'Spills, debris, or trash',
    ),
    IssueCategory(
      name: 'Broken Equipment',
      icon: Icons.construction_outlined,
      desc: 'Damaged fixtures',
    ),
    IssueCategory(
      name: 'Escalator',
      icon: Icons.stairs_outlined,
      desc: 'Not moving or noisy',
    ),
    IssueCategory(
      name: 'Elevator',
      icon: Icons.elevator_outlined,
      desc: 'Technical issues',
    ),
    IssueCategory(
      name: 'Lighting',
      icon: Icons.lightbulb_outline,
      desc: 'Flickering or out',
    ),
    IssueCategory(
      name: 'Restroom',
      icon: Icons.wc_outlined,
      desc: 'Plumbing or hygiene',
    ),
    IssueCategory(
      name: 'Water Leakage',
      icon: Icons.water_drop_outlined,
      desc: 'Ceiling or floor leaks',
    ),
    IssueCategory(
      name: 'Electrical',
      icon: Icons.bolt_outlined,
      desc: 'Exposed wires or power',
    ),
    IssueCategory(
      name: 'Air Conditioning',
      icon: Icons.ac_unit_outlined,
      desc: 'HVAC issues',
    ),
    IssueCategory(
      name: 'Safety Hazard',
      icon: Icons.warning_amber_outlined,
      desc: 'Dangerous areas',
    ),
    IssueCategory(
      name: 'Food Court',
      icon: Icons.restaurant_outlined,
      desc: 'Spills or damage',
    ),
    IssueCategory(
      name: 'Parking',
      icon: Icons.local_parking_outlined,
      desc: 'Parking issues',
    ),
    IssueCategory(
      name: 'Signage',
      icon: Icons.info_outline,
      desc: 'Broken signage',
    ),
    IssueCategory(
      name: 'Floor Damage',
      icon: Icons.layers_outlined,
      desc: 'Damaged flooring',
    ),
    IssueCategory(
      name: 'Other',
      icon: Icons.help_outline,
      desc: 'Other issues',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 1.15,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = cat.name == selectedCategory;

            return GestureDetector(
              onTap: () => onCategorySelected(cat.name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 14.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFEADDFF)
                      : Colors.white, // primary-fixed / white
                  borderRadius: BorderRadius.circular(24.0), // rounded-3xl
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6100D6)
                        : const Color(
                            0xFFCCC3D9,
                          ).withOpacity(0.2), // primary / outline-variant
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFF6100D6).withOpacity(0.08)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: isSelected ? 16.0 : 10.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Container
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFF8F9FF),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        cat.icon,
                        color: const Color(0xFF6100D6), // primary
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30), // on-surface
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      cat.desc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.0,
                        color: Color(0xFF4A4456), // on-surface-variant
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
