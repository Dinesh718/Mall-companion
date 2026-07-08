import 'package:flutter/material.dart';
import '../../domain/entities/theatre_entities.dart';
import 'showtime_chip.dart';

class TheatreInfoCard extends StatelessWidget {
  final TheatreEntity theatre;
  final List<ShowTimeEntity> showTimes;
  final String? selectedShowTimeId;
  final Function(String) onShowTimeSelected;

  const TheatreInfoCard({
    super.key,
    required this.theatre,
    required this.showTimes,
    required this.selectedShowTimeId,
    required this.onShowTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Separate facilities: display IMAX/4K like pills in top-right
    final topPills = theatre.facilities.where((f) => f.toUpperCase() == 'IMAX' || f.toUpperCase() == '4K' || f.toUpperCase() == '3D').toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0), // rounded-[24px]
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.1), // outline-variant/10
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Theatre Name & Pill Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theatre.name,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6100D6), // primary
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '${theatre.floorText} • ${theatre.screenText}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                    ),
                  ],
                ),
              ),
              if (topPills.isNotEmpty)
                Row(
                  children: topPills.map((pill) {
                    return Container(
                      margin: const EdgeInsets.only(left: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EBFA), // surface-container
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        pill.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4456), // on-surface-variant
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
          const SizedBox(height: 24.0),

          // Show Times Selection list
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: showTimes.map((st) {
                final isSelected = selectedShowTimeId == st.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ShowtimeChip(
                    time: st.time,
                    isSelected: isSelected,
                    onTap: () => onShowTimeSelected(st.id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
