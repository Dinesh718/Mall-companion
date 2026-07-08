import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entities.dart';

class RestaurantTableCard extends StatelessWidget {
  final TableSlotEntity slot;
  final bool isSelected;
  final VoidCallback onTap;

  const RestaurantTableCard({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isReserved = slot.status.toLowerCase() == 'reserved';

    return GestureDetector(
      onTap: isReserved ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isReserved
              ? const Color(0xFFEDE5F5) // disabled style
              : isSelected
              ? const Color(0xFF6100D6) // primary selection
              : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6100D6)
                : const Color(0xFFEDE5F5),
            width: 1.5,
          ),
          boxShadow: [
            if (!isReserved)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10.0,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              slot.timeSlot,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isReserved
                    ? const Color(0xFF7B7488)
                    : isSelected
                    ? Colors.white
                    : const Color(0xFF1D1A25),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              isReserved ? 'Reserved' : '${slot.tableSize} Guests',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11.0,
                color: isReserved
                    ? const Color(0xFF7B7488)
                    : isSelected
                    ? Colors.white70
                    : const Color(0xFF4A4456),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
